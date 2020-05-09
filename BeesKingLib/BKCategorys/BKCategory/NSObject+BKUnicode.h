//
//  NSObject+BKUnicode.h
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//  此文件用于打印的时候，将文字转成--utf8输出

#import <Foundation/Foundation.h>


@interface NSObject (BKUnicode)

+ (NSString *)BKStringByReplaceUnicodeString:(NSString *)unicodeString;

@end

@interface NSArray (BKUnicode)

@end

@interface NSDictionary (BKUnicode)

@end
