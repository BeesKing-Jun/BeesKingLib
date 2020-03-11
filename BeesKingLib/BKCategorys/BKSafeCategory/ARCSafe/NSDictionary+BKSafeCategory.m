//
//  NSDictionary+BKSafeCategory.m
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//

#import "NSDictionary+BKSafeCategory.h"
#import <objc/runtime.h>
#import "NSObject+BKMethodSwizzling.h"

@implementation NSDictionary (BKSafeCategory)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSPlaceholderDictionary") BKSwizzleInstanceSelector:@selector(initWithObjects:forKeys:count:) swizzledSelector:@selector(BKSafe_initWithObjects:forKeys:count:)];

    });
}

- (instancetype)BKSafe_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    
    id instance = nil;
    
    //以下是对错误数据的处理，把为nil的数据去掉,然后初始化字典
    NSInteger newObjsIndex = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];

    for (int i = 0; i < cnt; i++) {
        if (objects[i]&&keys[i]) {
            newObjects[newObjsIndex] = objects[i];
            newkeys[newObjsIndex] = keys[i];
            newObjsIndex ++;
        }else if(!keys[i]){
            NSAssert(keys[i],@"removed nil key-value because key is nil");
        }else{
            NSAssert(objects[i], @"removed nil key-value because value is nil");
        }
    }
    
    instance = [self BKSafe_initWithObjects:newObjects forKeys:newkeys count:newObjsIndex];
    
    return instance;
}

@end
