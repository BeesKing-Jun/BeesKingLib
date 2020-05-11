//
//  BKRequestUtil.h
//  BeesKingLib
//
//  Created by WJ on 2020/5/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.

#import <Foundation/Foundation.h>


@interface BKRequestUtil : NSObject

+ (BOOL)judgeFilePathExistWith:(NSString *)path;

/**字典key排序，返回排序好的数组*/
+ (NSArray *)sortedByDictionaryKeyWithDic:(NSDictionary *)dic;

/**字符串md5加密*/
+ (NSString *)md5Hash:(NSString *)str;

@end

