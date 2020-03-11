//
//  NSArray+BKSafeCategory.m
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 WJ. All rights reserved.
//

#import "NSArray+BKSafeCategory.h"
#import "NSObject+BKMethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSArray (BKSafeCategory)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayI") BKSwizzleInstanceSelector:@selector(objectAtIndex:) swizzledSelector:@selector(BKSafeI_ObjectAtIndex:)];
        [objc_getClass("__NSArray0") BKSwizzleInstanceSelector:@selector(objectAtIndex:) swizzledSelector:@selector(BKSafe0_ObjectAtIndex:)];
        [objc_getClass("__NSPlaceholderArray") BKSwizzleInstanceSelector:@selector(initWithObjects:count:) swizzledSelector:@selector(BKSafe_initWithObjects:count:)];

    });
}

- (instancetype)BKSafe_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    
    id instance = nil;
    
    //以下是对错误数据的处理，把为nil的数据去掉,然后初始化数组
    NSInteger newObjsIndex = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    
    for (int i = 0; i < cnt; i++) {
        if (objects[i]) {
            newObjects[newObjsIndex] = objects[i];
            newObjsIndex ++;
        }else{
            NSAssert(objects[i], @"*** object is nil ***");
        }
    }
    
    instance = [self BKSafe_initWithObjects:newObjects count:newObjsIndex];
    
    return instance;
}

- (id)BKSafeI_ObjectAtIndex:(NSUInteger)index {
    
    if (self.count == 0) {
        NSAssert(NO, @"*** Array is empty ***");
        return nil;
    }
    if (index >= self.count) {
        NSAssert(NO, @"*** index out of bound ***");
        return nil;
    }
    return [self BKSafeI_ObjectAtIndex:index];
}

- (id)BKSafe0_ObjectAtIndex:(NSUInteger)index {
    
    if (self.count == 0) {
        NSAssert(NO, @"*** Array is empty ***");
        return nil;
    }
    if (index >= self.count) {
        NSAssert(NO, @"*** index out of bound ***");
        return nil;
    }
    return [self BKSafe0_ObjectAtIndex:index];
}

@end
