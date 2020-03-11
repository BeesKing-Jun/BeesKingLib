//
//  NSObject+BKMethodSwizzling.h
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//  继承于NSObject 的方法交换，类簇的实例方法交换不能使用 [self class]

#import <Foundation/Foundation.h>


@interface NSObject (BKMethodSwizzling)

+ (void)BKSwizzleInstanceSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
+ (void)BKSwizzleClassSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

