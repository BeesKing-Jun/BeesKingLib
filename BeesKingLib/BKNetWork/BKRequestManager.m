//
//  BKRequestManager.m
//  BeesKingLib
//
//  Created by WJ on 2020/5/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.

#import "BKRequestManager.h"
#import "BKBaseRequest.h"

//--打印相关
#ifdef DEBUG

#define BKLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];\
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
printf("%s %s [第%d行]\n method: %s \n %s\n",[str UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(FORMAT), ##__VA_ARGS__] UTF8String]);\
}
#else
#define BKLog(...)
#endif

@implementation BKRequestManager

+ (instancetype)shareManager
{
    static BKRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BKRequestManager alloc] init];
    });
    manager.httpSessionManager.requestSerializer.timeoutInterval = 20.0;
    return manager;
}

- (NSString *)requestMD5Key
{
    if(_requestMD5Key == nil){
        return @"";
    }
    return _requestMD5Key;
}

- (instancetype)init
{
    if(self = [super init]){
        self.httpSessionManager = [[AFHTTPSessionManager alloc] init];
        self.httpSessionManager.requestSerializer.timeoutInterval = 20.0;
        self.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"audio/mpeg",@"image/jpeg",@"image/png", @"application/octet-stream",nil];
       
    }
    return self;
}

- (void)setNeedHttpsCverification:(BOOL)needHttpsCverification
{
    _needHttpsCverification = needHttpsCverification;
    if (needHttpsCverification) {
        [self.httpSessionManager setSecurityPolicy:self.securityPolicy];
    }
}

//发送接口请求---普通请求
- (void)sendRequestWithRequest:(BKBaseRequest *)request successed:(void(^)(id responseObject))successBlock failed:(void(^)(NSError *error))failedBlock{
    
    [self sendRequestWithRequest:request successed:successBlock failed:failedBlock progress:nil];
}

- (void)cancelRequest{
    
    [self.httpSessionManager.operationQueue cancelAllOperations];
}

//发送请求,带进度回调 ---可以用于上传、下载等
- (void)sendRequestWithRequest:(BKBaseRequest *)request successed:(void (^)(id responseObject))successBlock failed:(void (^)(NSError *))failedBlock progress:(void (^)(NSProgress *))progressBlock{
    self.httpSessionManager.requestSerializer.timeoutInterval = 20.0;
    switch (request.requestType) {
        case BKRequestType_POST:{
            [self BKPostWithRequest:request successed:successBlock failed:failedBlock];
            break;
        }
        case BKRequestType_GET:{
            [self BKGETWithRequest:request successed:successBlock failed:failedBlock];
            break;
        }
        case BKRequestType_UPLOAD:{
            [self BKUploadImageWith:request successed:successBlock failed:failedBlock progress:progressBlock];
            break;
        }
        case BKRequestType_DOWNLOAD:{
            
            break;
        }
            
        default:
            break;
    }
}

// POST请求
- (void)BKPostWithRequest:(BKBaseRequest *)request successed:(void(^)(id responseObject))successBlock failed:(void(^)(NSError *error))failedBlock{
    NSString * URLString = [self getURLString:request];
    [self setHeaderParams:request];

    BKLog(@"BKBaseRequest--%@\n Params--%@",URLString,request.params);
    
    request.requestTask = [self.httpSessionManager POST:URLString parameters:request.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BKLog(@"BKBaseRequest--%@\n header--%@\nParams--%@\n请求结果为%@", URLString, self.httpSessionManager.requestSerializer.HTTPRequestHeaders,request.params, responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        BKLog(@"请求失败");
        failedBlock(error);
    }];
}

//GET请求
- (void)BKGETWithRequest:(BKBaseRequest *)request successed:(void(^)(id responseObject))successBlock failed:(void(^)(NSError *error))failedBlock{
    NSString * URLString = [self getURLString:request];
    [self setHeaderParams:request];
    BKLog(@"BKBaseRequest--%@\n Params--%@", URLString, request.params);
    request.requestTask = [self.httpSessionManager GET:URLString parameters:request.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BKLog(@"BKBaseRequest--%@\n header--%@\nParams--%@\n请求结果为%@", URLString, self.httpSessionManager.requestSerializer.HTTPRequestHeaders,request.params, responseObject);
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        BKLog(@"请求失败");
        failedBlock(error);
    }];
}

//上传文件
- (void)BKUploadImageWith:(BKBaseRequest *)request successed:(void(^)(id responseObject))successBlock failed:(void(^)(NSError *error))failedBlock progress:(void(^)(NSProgress * uploadProgress))progressBlock{
    
    self.httpSessionManager.requestSerializer.timeoutInterval = 20.0;
    NSString * URLString = [self getURLString:request];
    [self setHeaderParams:request];
    BKLog(@"BKBaseRequest--%@\n Params--%@", URLString, request.params);
    
    request.requestTask = [self.httpSessionManager POST:URLString parameters:request.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        //绑定上传数据
        switch (request.uploadFileModel.sourceType) {
            case BKUpLoadSourceType_Data:{
                if(request.uploadFileModel.uploadData){
                    [formData appendPartWithFileData:request.uploadFileModel.uploadData name:request.uploadFileModel.imageName fileName:request.uploadFileModel.imageFileName mimeType:request.uploadFileModel.imageType];
                }
                break;
            }
            case BKUpLoadSourceType_FilePath:{
                NSURL *URL = [NSURL fileURLWithPath:request.uploadFileModel.sourceFilePath];

                [formData appendPartWithFileURL:URL name:request.uploadFileModel.imageName fileName:request.uploadFileModel.imageFileName mimeType:request.uploadFileModel.imageType error:nil];
                break;
            }
            case BKUpLoadSourceType_URL:{
                NSURL * URL = [NSURL URLWithString:request.uploadFileModel.sourceURLString];
                [formData appendPartWithFileURL:URL name:request.uploadFileModel.imageName error:nil];
                break;
            }
            default:
                break;
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //进度回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if(progressBlock){
                progressBlock(uploadProgress);
            }
        });

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BKLog(@"BKBaseRequest--%@\n header--%@\n Params--%@\n dataParams -- %@\n请求结果为%@", URLString, self.httpSessionManager.requestSerializer.HTTPRequestHeaders,request.params, request.dataParams, responseObject);
        //上传成功回调
        if(successBlock){
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //上传失败回调
        if(failedBlock){
            failedBlock(error);
        }
    }];
    
}

//拼装请求地址
- (NSString *)getURLString:(BKBaseRequest *)request
{
    NSString * URLString = nil;
    if(![request.URLString hasPrefix:@"http"]){
        URLString = [NSString stringWithFormat:@"%@%@", request.baseURL, request.URLString];
    }else{
        URLString = request.URLString;
    }
    
    return URLString;
}

- (void)setHeaderParams:(BKBaseRequest *)request
{
    self.httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    if (request.headerParams) {
        [request.headerParams.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.httpSessionManager.requestSerializer setValue:[request.headerParams objectForKey:obj] forHTTPHeaderField:[NSString stringWithFormat:@"%@", obj]];
        }];
    }
}

- (void)cancelRequestWithURLString:(NSString *)URLString{
    for (NSURLSessionTask * task in self.httpSessionManager.tasks) {
        if([task.currentRequest.URL.absoluteString containsString:URLString]){
            [task cancel];
        }
    }
}

@end
