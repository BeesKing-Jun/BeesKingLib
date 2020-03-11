//
//  NSMutableArray+BKSafeCategory.h
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 WJ. All rights reserved.
//

#import "NSMutableArray+BKSafeCategory.h"
#import "NSObject+BKMethodSwizzling.h"
#import <objc/runtime.h>


@implementation NSMutableArray (BKSafeCategory)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") BKSwizzleInstanceSelector:@selector(addObject:) swizzledSelector:@selector(BKSafe_AddObject:)];
        [objc_getClass("__NSArrayM") BKSwizzleInstanceSelector:@selector(removeObjectAtIndex:) swizzledSelector:@selector(BKSafe_RemoveObjectAtIndex:)];
        [objc_getClass("__NSArrayM") BKSwizzleInstanceSelector:@selector(insertObject:atIndex:) swizzledSelector:@selector(BKSafe_InsertObject:atIndex:)];
        [objc_getClass("__NSArrayM") BKSwizzleInstanceSelector:@selector(objectAtIndex:) swizzledSelector:@selector(BKSafeM_ObjectAtIndex:)];
    });
}

- (void)BKSafe_AddObject:(id)obj {
    @autoreleasepool {
        if (!obj) {
            NSAssert(obj, @"***object cannot be nil ***");
        } else {
            [self BKSafe_AddObject:obj];
        }
    }
}

- (void)BKSafe_InsertObject:(id)anObject atIndex:(NSUInteger)index {
    @autoreleasepool {
        if (!anObject) {
            NSAssert(anObject, @"***object cannot be nil ***");
        } else if (index > self.count) {
            NSAssert(NO, @"*** index out of bound ***");
        } else {
            [self BKSafe_InsertObject:anObject atIndex:index];
        }
    }
}

- (id)BKSafeM_ObjectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        if (self.count == 0) {
            NSAssert(NO, @"*** Array is empty ***");
            return nil;
        }
        if (index >= self.count) {
            NSAssert(NO, @"*** index out of bound ***");
            return nil;
        }
        return [self BKSafeM_ObjectAtIndex:index];
    }
}

- (void)BKSafe_RemoveObjectAtIndex:(NSUInteger)index {
    @autoreleasepool {
        if (index >= self.count||self.count <= 0) {
            NSAssert(NO, @"*** index out of bound ***");
            return;
        }
        [self BKSafe_RemoveObjectAtIndex:index];
    }
}

@end
