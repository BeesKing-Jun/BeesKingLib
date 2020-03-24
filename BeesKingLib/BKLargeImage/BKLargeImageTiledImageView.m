//
//  BKLargeImageTiledImageView.m
//  BeesKingLib
//
//  Created by TY on 2020/3/22.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//  加载大图

#import "BKLargeImageTiledImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface BKLargeImageTiledImageView ()

@property (nonatomic, assign) CGFloat imageScale;

@property (nonatomic, assign) CGRect imageRect;

@property (nonatomic, strong) UIImage* image;

@end

@implementation BKLargeImageTiledImageView

// 重写layerClass
+ (Class)layerClass {
	return [CATiledLayer class];
}

-(id)initWithFrame:(CGRect)frame image:(UIImage*)img scale:(CGFloat)scale {
    if ((self = [super initWithFrame:frame])) {
		self.image = img;
        self.imageRect = CGRectMake(0.0f, 0.0f, CGImageGetWidth(self.image.CGImage), CGImageGetHeight(self.image.CGImage));
		self.imageScale = scale;
 		CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];

        int levelsOfDetailBias = ceil(log2(1/scale))+1;
        
        tiledLayer.levelsOfDetail = 4;
		tiledLayer.levelsOfDetailBias = levelsOfDetailBias;
		tiledLayer.tileSize = CGSizeMake(512.0, 512.0);	//CATiledLayer区域最大尺寸
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();    
	CGContextSaveGState(context);

	CGContextScaleCTM(context, self.imageScale, self.imageScale);
	CGContextDrawImage(context, self.imageRect, self.image.CGImage);
	CGContextRestoreGState(context);
}

@end
