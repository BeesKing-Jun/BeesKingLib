//
//  BKMediator.h
//  BeesKingLib
//
//  Created by WJ on 2020/3/9.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kBKMediatorParamsKeySwiftTargetModuleName;
@interface BKMediator : NSObject

+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
// 本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
