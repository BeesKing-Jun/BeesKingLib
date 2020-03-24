//
//  BKLargeImageTiledImageView.h
//  BeesKingLib
//
//  Created by TY on 2020/3/22.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//  加载大图

#import <UIKit/UIKit.h>

@interface BKLargeImageTiledImageView : UIView

-(id)initWithFrame:(CGRect)frame image:(UIImage*)img scale:(CGFloat)scale;

@end
