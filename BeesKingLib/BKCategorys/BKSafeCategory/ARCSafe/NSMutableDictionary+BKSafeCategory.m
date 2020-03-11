//
//  NSMutableDictionary+BKSafeCategory.m
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 WJ. All rights reserved.
//

#import "NSMutableDictionary+BKSafeCategory.h"
#import "NSObject+BKMethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (BKSafeCategory)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryM") BKSwizzleInstanceSelector:@selector(setObject:forKey:) swizzledSelector:@selector(BKSafe_setObject:forKey:)];
    });
}

- (void)BKSafe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (!anObject) {
        NSAssert(anObject,@"*** setObjectForKey: key cannot be nil");
        return;
    } else if(!aKey) {
        NSString *str = [NSString stringWithFormat:@"*** setObjectForKey: object cannot be nil forKey:%@",aKey];
        NSAssert(aKey,str);
        return;
    }
    
    [self BKSafe_setObject:anObject forKey:aKey];
}

@end
