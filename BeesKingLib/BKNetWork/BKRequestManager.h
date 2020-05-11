//
//  BKRequestManager.h
//  BeesKingLib
//
//  Created by WJ on 2020/5/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class BKBaseRequest;
@interface BKRequestManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, copy) NSString *requestMD5Key;
@property (nonatomic, assign) BOOL needHttpsCverification;/**<是否需要https证书认证，默认不需要*/

@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;/**<https证书验证策略，外部导入*/

@property (nonatomic, copy) NSString *requestURLCachePath;
@property (nonatomic, copy) NSString *requestPDFPath;

/**AFNetWorking */
@property (nonatomic, strong)AFHTTPSessionManager *httpSessionManager;

/**发送接口请求---普通请求*/
- (void)sendRequestWithRequest:(BKBaseRequest *)request successed:(void(^)(id responseObject))successBlock failed:(void(^)(NSError *error))failedBlock;

/**发送请求,带进度回调 ---主要用于上传、下载等*/
- (void)sendRequestWithRequest:(BKBaseRequest *)request successed:(void(^)(id responseObject))successBlock failed:(void(^)(NSError *error))failedBlock progress:(void (^)(NSProgress *))progressBlock;

- (void)cancelRequest;

- (void)cancelRequestWithURLString:(NSString *)URLString;

@end

