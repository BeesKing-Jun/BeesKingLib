//
//  BKBaseRequest.m
//  BeesKingLib
//
//  Created by WJ on 2020/5/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.

#import "BKBaseRequest.h"
#import "BKRequestUtil.h"

@implementation BKBaseRequest



- (instancetype)init
{
    if(self = [super init]){
        _requestType = BKRequestType_POST;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSString *)baseURL URLString:(NSString *)URLString params:(NSDictionary *)params
{
    if(self = [super init]){
        _baseURL = baseURL;
        _URLString = URLString;
        _params = params;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSString *)baseURL URLString:(NSString *)URLString params:(NSDictionary *)params dataParams:(NSDictionary *)dataParams
{
    if(self = [super init]){
        _baseURL = baseURL;
        _URLString = URLString;
        _params = params;
        _dataParams = dataParams;
    }
    return self;
}

//拼装请求地址
- (NSString *)getUrlString
{
    NSString * urlString = @"";
    if(![self.URLString hasPrefix:@"http"]){
        urlString = [NSString stringWithFormat:@"%@%@",self.baseURL, self.URLString];
    }else{
        urlString = self.URLString;
    }
    
    if(self.params){
        NSArray * sortedKeys = [BKRequestUtil sortedByDictionaryKeyWithDic:self.params];
        __block NSString *paramStr = [NSString stringWithFormat:@"%@?", urlString];
        [sortedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            paramStr = [paramStr stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,self.params[key]]];
            if (idx != sortedKeys.count - 1) {
                paramStr = [paramStr stringByAppendingString:@"&"];
            }
        }];
        return paramStr;
    }
    return urlString;
}

@end

@implementation BKRequestFileUpload


@end
