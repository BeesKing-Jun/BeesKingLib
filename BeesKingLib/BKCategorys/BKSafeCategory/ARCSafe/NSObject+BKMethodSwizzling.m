//
//  NSObject+BKMethodSwizzling.m
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//  

#import "NSObject+BKMethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (BKMethodSwizzling)

+ (void)BKSwizzleClassSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class clazz = object_getClass(self);
    
    Method originAddObserverMethod = class_getClassMethod(clazz, originalSelector);
    Method swizzledAddObserverMethod = class_getClassMethod(clazz, swizzledSelector);
    
    [self BKSwizzleMethodWithOriginalSelector:originalSelector originalMethod:originAddObserverMethod swizzledSelector:swizzledSelector swizzledMethod:swizzledAddObserverMethod class:clazz];
}

+ (void)BKSwizzleInstanceSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originAddObserverMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swizzledSelector);
    
    [self BKSwizzleMethodWithOriginalSelector:originalSelector originalMethod:originAddObserverMethod swizzledSelector:swizzledSelector swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)BKSwizzleMethodWithOriginalSelector:(SEL)originalSelector
                             originalMethod:(Method)originalMethod
                           swizzledSelector:(SEL)swizzledSelector
                             swizzledMethod:(Method)swizzledMethod
                                      class:(Class)clazz {
    BOOL didAddMethod = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
