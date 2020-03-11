//
//  UIControl+BKFixMultiClick.h
//  BeesKingLib
//
//  Created by WJ on 2020/3/9.
//  Copyright © 2020年 WJ. All rights reserved.
//  UIControl分类，用于防止重复点击

#import <UIKit/UIKit.h>

@interface UIControl (BKFixMultiClick)
/**重复点击的间隔（秒）*/
@property (nonatomic, assign) NSTimeInterval BKAcceptEventInterval;

@end

