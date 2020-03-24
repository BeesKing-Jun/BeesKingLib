//
//  BKLargeImageScrollView.m
//  BeesKingLib
//
//  Created by TY on 2020/3/22.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//  加载大图

#import "BKLargeImageScrollView.h"
#import "BKLargeImageTiledImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface BKLargeImageScrollView () <UIScrollViewDelegate>

// 前置TiledImageView
@property (nonatomic, strong) BKLargeImageTiledImageView *frontTiledView;

// 缩放停止时，绘制的TiledImageView
@property (nonatomic, strong) BKLargeImageTiledImageView *backTiledView;

// 低分辨率的imageView
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) float minimumScale;

@property (nonatomic, assign) CGFloat imageScale;

@end

@implementation BKLargeImageScrollView;


-(id)initWithFrame:(CGRect)frame image:(UIImage*)img {
    if((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        // 快速减速
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
		self.maximumZoomScale = 5.0f;
		self.minimumZoomScale = 0.25f;
        
        self.image = img;
        
        CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(self.image.CGImage),CGImageGetHeight(self.image.CGImage));
        self.imageScale = self.frame.size.width/imageRect.size.width;
        self.minimumScale = self.imageScale * 0.75f;
        
        imageRect.size = CGSizeMake(imageRect.size.width*self.imageScale, imageRect.size.height*self.imageScale);

        UIGraphicsBeginImageContext(imageRect.size);		
        CGContextRef context = UIGraphicsGetCurrentContext();		
        CGContextSaveGState(context);
        CGContextDrawImage(context, imageRect, self.image.CGImage);
        CGContextRestoreGState(context);		
        UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();		
        UIGraphicsEndImageContext();
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        self.backgroundImageView.frame = imageRect;
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.backgroundImageView];
        [self sendSubviewToBack:self.backgroundImageView];

        self.frontTiledView = [[BKLargeImageTiledImageView alloc] initWithFrame:imageRect image:self.image scale:self.imageScale];
        [self addSubview:self.frontTiledView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 当图像变得小于屏幕尺寸时，使图像居中
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.frontTiledView.frame;
    
    // 水平居中
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // 垂直居中
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    self.frontTiledView.frame = frameToCenter;
	self.backgroundImageView.frame = frameToCenter;
}

#pragma mark - UIScrollView delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.frontTiledView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
	self.imageScale *= scale;
    
    if( self.imageScale < self.minimumScale ) self.imageScale = self.minimumScale;
    
    CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(self.image.CGImage) * self.imageScale,CGImageGetHeight(self.image.CGImage) * self.imageScale);

	self.frontTiledView = [[BKLargeImageTiledImageView alloc] initWithFrame:imageRect image:self.image scale:self.imageScale];
	[self addSubview:self.frontTiledView];
}

// 开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
	[self.backTiledView removeFromSuperview];
	self.backTiledView = self.frontTiledView;
}

@end
