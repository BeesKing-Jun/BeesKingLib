//
//  BKLargeImageView.m
//  BeesKingLib
//
//  Created by TY on 2020/3/24.
//  加载大图

#import "BKLargeImageView.h"
#import <QuartzCore/QuartzCore.h>
#import <BeesKingLib/BKLargeImageScrollView.h>

#define kLIMainScreenScale ([UIScreen mainScreen].scale)

/// 目标image的大小(MB)
#define kLIDestImageSizeMB (40.0f*kLIMainScreenScale)

/// 切片图片大小(MB)
#define kLISourceImageTileSizeMB (15.0f*kLIMainScreenScale)

/// 目标图片总得像素数量
#define kLIDestTotalPixels kLIDestImageSizeMB * kLIPixelsPerMB

/// 未压缩图片的切片包含的像素数量
#define kLITileTotalPixels kLISourceImageTileSizeMB * kLIPixelsPerMB

/// 1MB=1024KB=1024*1024字节
static const CGFloat kLIBytesPerMB = 1048576.0f;

/// 1像素4字节
static const CGFloat kLIBytesPerPixel = 4.0f;

/// 1MB中有多少像素
static CGFloat kLIPixelsPerMB = (kLIBytesPerMB / kLIBytesPerPixel );

@interface BKLargeImageView ()

// The input image file
@property (nonatomic, strong) UIImage* sourceImage;

// output image file
@property (nonatomic, strong) UIImage* destImage;

@property (nonatomic, assign) CGContextRef destContext;

// 图像视图以将图像拼合时可视化
@property (nonatomic, strong) UIImageView* progressView;

// 滚动视图以显示生成的缩小图像
@property (nonatomic, strong) BKLargeImageScrollView* scrollView;

@property (nonatomic, copy) NSString *imageName;

@end

@implementation BKLargeImageView

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageName = imageName;
        self.progressView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.progressView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.progressView];

        [NSThread detachNewThreadSelector:@selector(downsize) toTarget:self withObject:nil];
    }
    
    return self;
}

-(void)downsize{
    /// 目标图片重叠的像素数，值越小，越有可能出现没有重叠的问题
    CGFloat destSeemOverlap  = 2.0f;
    
    @autoreleasepool {
        self.sourceImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.imageName ofType:nil]];
        if( self.sourceImage == nil ) {
            self.sourceImage = [UIImage imageNamed:self.imageName];

            if (self.sourceImage == nil){
                NSLog(@"LargeImage error:input image not found!");
                return;
            }
        };
        
        CGSize sourceResolution;
        // 原始图片的在像素上的宽高：
        sourceResolution.width = CGImageGetWidth(self.sourceImage.CGImage);
        sourceResolution.height = CGImageGetHeight(self.sourceImage.CGImage);
        
        // 计算原图像总像素
        float sourceTotalPixels = sourceResolution.width * sourceResolution.height;
        
        // 根据机型计算出压缩比例
        float imageScale = kLIDestTotalPixels / sourceTotalPixels;

        // 如果目标大小比源大小大，直接绘制
        if (imageScale >= 1) {
            self.destImage = self.sourceImage;
            [self performSelectorOnMainThread:@selector(initializeScrollView) withObject:nil waitUntilDone:YES];

            return;
        }
        
        CGSize destResolution;
        // 输出图片的宽高
        destResolution.width = (int)( sourceResolution.width * imageScale );
        destResolution.height = (int)( sourceResolution.height * imageScale );

        // 创建colorSpace
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // bitmap的每一行在内存所占的比特数
        int bytesPerRow = kLIBytesPerPixel * destResolution.width;
        // 分配bitmap所需要的大小
        void* destBitmapData = malloc( bytesPerRow * destResolution.height );

        if (destBitmapData == NULL){
            NSLog(@"LargeImage error:failed to allocate space for the output image!");
            return;
        }
        
        // 创建输出(缩放)目标图片的context：
        self.destContext = CGBitmapContextCreate(destBitmapData, destResolution.width, destResolution.height, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast );

        if( self.destContext == NULL ) {
            free( destBitmapData );

            NSLog(@"LargeImage error:failed to create the output bitmap context!");
            return;
        }
        CGColorSpaceRelease( colorSpace );
        
        //通过调用CGContextTranslateCTM函数来修改每个点的x, y坐标值
        CGContextTranslateCTM(self.destContext, 0.0f, destResolution.height);

        CGContextScaleCTM(self.destContext, 1.0f, -1.0f );
        
        CGRect sourceTile;
        // 原切片的宽高
        sourceTile.size.width = sourceResolution.width;
        sourceTile.size.height = (int)( kLITileTotalPixels / sourceTile.size.width );
        
        sourceTile.origin.x = 0.0f;

        CGRect destTile;
        // 目标切片宽高
        destTile.size.width = destResolution.width;
        // 根据比例计算目标tile的高度：
        destTile.size.height = sourceTile.size.height * imageScale;
        destTile.origin.x = 0.0f;

        // 计算source重叠的像素，拼装时与图块重叠的像素数
        float sourceSeemOverlap = (int)( ( destSeemOverlap / destResolution.height ) * sourceResolution.height );

        CGImageRef sourceTileImageRef;
        // 计算需要绘制的次数
        int iterations = (int)(sourceResolution.height / sourceTile.size.height );
        int remainder = (int)sourceResolution.height % (int)sourceTile.size.height;
        if( remainder ) iterations++;
        
        float sourceTileHeightMinusOverlap = sourceTile.size.height;
        sourceTile.size.height += sourceSeemOverlap;
        destTile.size.height += destSeemOverlap;
        
        // 根据tile的个数进行循环，把每一个原始图片的tile绘制到context中，代码里的注释提到了，CGContextDrawImage调用时数据会被解码。
        for( int y = 0; y < iterations; ++y ) {
            @autoreleasepool {

                NSLog(@"iteration %d of %d",y+1,iterations);
                
                sourceTile.origin.y = y * sourceTileHeightMinusOverlap + sourceSeemOverlap;
                destTile.origin.y = ( destResolution.height ) - ( ( y + 1 ) * sourceTileHeightMinusOverlap * imageScale + destSeemOverlap );
            
                // 获取截取的图片
                sourceTileImageRef = CGImageCreateWithImageInRect( self.sourceImage.CGImage, sourceTile );
                
                // 最后一个切片
                if( y == iterations - 1 && remainder ) {
                    float dify = destTile.size.height;
                    destTile.size.height = CGImageGetHeight( sourceTileImageRef ) * imageScale;
                    dify -= destTile.size.height;
                    destTile.origin.y += dify;
                }
                
                // draw切片到context
                CGContextDrawImage( self.destContext, destTile, sourceTileImageRef );

                CGImageRelease( sourceTileImageRef );
            }
            
            // 更新scrollView
            if( y < iterations - 1 ) {
                [self performSelectorOnMainThread:@selector(updateProgressView) withObject:nil waitUntilDone:YES];
            }
        }
        
        NSLog(@"downsize complete.");
        [self performSelectorOnMainThread:@selector(downsizeComplete) withObject:nil waitUntilDone:YES];

        CGContextRelease( self.destContext );
    }
    
}

-(void)createImageFromContext {
    CGImageRef destImageRef = CGBitmapContextCreateImage( self.destContext );
    if( destImageRef == NULL ) NSLog(@"destImageRef is null.");
    
    self.destImage = [UIImage imageWithCGImage:destImageRef scale:1.0f orientation:UIImageOrientationDownMirrored];
    
    CGImageRelease( destImageRef );
    if( self.destImage == nil ) NSLog(@"destImage is nil.");
}

-(void)updateProgressView{
    [self createImageFromContext];
    
    self.progressView.image = self.destImage;
}

-(void)downsizeComplete{
    [self.progressView removeFromSuperview];
    [self createImageFromContext];
    
    [self initializeScrollView];
}

- (void)initializeScrollView{
    self.scrollView = [[BKLargeImageScrollView alloc] initWithFrame:self.bounds image:self.destImage];
    [self addSubview:self.scrollView];
}

@end
