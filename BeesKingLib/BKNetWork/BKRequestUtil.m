//
//  BKRequestUtil.m
//  BeesKingLib
//
//  Created by WJ on 2020/5/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.

#import "BKRequestUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation BKRequestUtil


+ (NSString *)md5Hash:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
}

+ (BOOL)judgeFilePathExistWith:(NSString *)path
{
    BOOL res = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        res = YES;
    }else{
        res = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return res;
}

+ (BOOL)cacheDataWithObject:(id)object path:(NSString *)cachePath{
    BOOL res = NO;
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:object];
    res = [data writeToFile:cachePath atomically:YES];
    
    return res;
}

+ (id)cacheDataForPath:(NSString *)cachePath{
    
    NSData * data = [NSData dataWithContentsOfFile:cachePath];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return object;
}

+ (BOOL)deleteCacheWithPath:(NSString *)cachePath{
    BOOL res = NO;
    
    res = [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    return res;
}

/**字典key排序，返回排序好的数组*/
+ (NSArray *)sortedByDictionaryKeyWithDic:(NSDictionary *)dic
{
    
    NSArray * allKeys = [dic allKeys];
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult  result = [obj1 compare:obj2];
        return result;
    }];
    
    return allKeys;
}

+ (NSString*)encodeString:(NSString*)unencodedString{
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

@end
