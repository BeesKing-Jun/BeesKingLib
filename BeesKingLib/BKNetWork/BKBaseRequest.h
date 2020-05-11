//
//  BKBaseRequest.h
//  BeesKingLib
//
//  Created by WJ on 2020/5/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.

#import <Foundation/Foundation.h>

/**请求类型*/
typedef NS_ENUM(NSInteger, BKRequestType) {
    BKRequestType_POST      = 0,    //POST请求
    BKRequestType_GET       = 1,    //GET请求
    BKRequestType_UPLOAD    = 2,    //上传
    BKRequestType_DOWNLOAD  = 3,    //下载
};

/**上传数据来源类型*/
typedef NS_ENUM(NSInteger, BKUpLoadSourceType) {
    BKUpLoadSourceType_Data     = 0,        //数据来源NSData
    BKUpLoadSourceType_FilePath = 1,        //数据来源本地文件
    BKUpLoadSourceType_URL      = 2,        //数据来源网络地址
};


@class BKRequestFileUpload;

@interface BKBaseRequest : NSObject

/**
 BKBaseRequest创建方法，同时配置参数
 
 @param baseURL 接口域名
 @param URLString 接口名字
 @param params 接口参数
 @return BKBaseRequest实例
 */
- (instancetype)initWithBaseURL:(NSString *)baseURL URLString:(NSString *)URLString params:(NSDictionary *)params;

/**请求参数字典*/
@property (nonatomic, copy)     NSDictionary *params;
/**设置在header里面的参数*/
@property (nonatomic, copy)     NSDictionary *headerParams;
/**请求地址，拼接在baseURL之后的部分*/
@property (nonatomic, copy)     NSString *URLString;
/**请求baseURL*/
@property (nonatomic, copy)     NSString *baseURL;
/**请求类型*/
@property (nonatomic, assign)   BKRequestType requestType;
/**当前请求任务，可取消*/
@property (nonatomic, strong)   NSURLSessionDataTask *requestTask;


#pragma mark - 上传图片、文件相关
/**
 BKBaseRequest创建方法，同时配置参数
 
 @param baseURL 接口域名
 @param URLString 接口名字
 @param params 接口参数
 @param dataParams data参数
 @return BKBaseRequest实例
 */
- (instancetype)initWithBaseURL:(NSString *)baseURL URLString:(NSString *)URLString params:(NSDictionary *)params dataParams:(NSDictionary *)dataParams;
/**上传文件的model*/
@property (nonatomic, strong)   BKRequestFileUpload *uploadFileModel;
/**文件参数字典*/
@property (nonatomic, copy)     NSDictionary *dataParams;

@end

@interface BKRequestFileUpload : NSObject

/**上传图片时需要的imagedata*/
@property (nonatomic, strong)   NSData *uploadData;
/**满足的图片上传的格式*/
@property (nonatomic, copy)     NSString *imageType;
/**上传图片的名字*/
@property (nonatomic, copy)     NSString *imageName;
/**图片的文件名*/
@property (nonatomic, copy)     NSString *imageFileName;
/**上传文件来源类型*/
@property (nonatomic, assign)   BKUpLoadSourceType sourceType;
/**本地文件地址*/
@property (nonatomic, copy)     NSString *sourceFilePath;
/**文件网络地址*/
@property (nonatomic, copy)     NSString *sourceURLString;

@end
