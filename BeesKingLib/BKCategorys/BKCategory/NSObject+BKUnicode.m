//
//  NSObject+BKUnicode.m
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//

#import "NSObject+BKUnicode.h"
#import <objc/runtime.h>

@implementation NSObject (ZQ_Unicode)

+(NSString *)BKStringByReplaceUnicodeString:(NSString *)unicodeString
{
    NSMutableString *converedString = [unicodeString mutableCopy];
    [converedString replaceOccurrencesOfString:@"\\U" withString:@"\\u" options:NSCaseInsensitiveSearch range:NSMakeRange(0, converedString.length)];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)converedString, NULL, transform, YES);
    return converedString ;
}

@end

@implementation NSArray (BKUnicode)

+(void)load
{
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(BKReplaceDescription)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:)), class_getInstanceMethod([self class], @selector(BKReplaceDescriptionWithLocale:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:indent:)), class_getInstanceMethod([self class], @selector(BKReplaceDescriptionWithLocale:indent:)));
}
-(NSString *)BKReplaceDescription
{
    return [NSObject BKStringByReplaceUnicodeString:[self BKReplaceDescription]];
}
-(NSString *)BKReplaceDescriptionWithLocale:(NSString *)string
{
    return [NSObject BKStringByReplaceUnicodeString:[self BKReplaceDescriptionWithLocale:string]];
}
-(NSString *)BKReplaceDescriptionWithLocale:(NSString *)string indent:(NSUInteger)level
{
    return [NSObject BKStringByReplaceUnicodeString:[self BKReplaceDescriptionWithLocale:string indent:level]];
}

@end

@implementation NSDictionary (BKUnicode)

+(void)load
{
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(description)), class_getInstanceMethod([self class], @selector(BKReplaceDescription)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:)), class_getInstanceMethod([self class], @selector(BKReplaceDescriptionWithLocale:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(descriptionWithLocale:indent:)), class_getInstanceMethod([self class], @selector(BKReplaceDescriptionWithLocale:indent:)));
}
-(NSString *)BKReplaceDescription
{
    return [NSObject BKStringByReplaceUnicodeString:[self BKReplaceDescription]];
}
-(NSString *)BKReplaceDescriptionWithLocale:(NSString *)string
{
    return [NSObject BKStringByReplaceUnicodeString:[self BKReplaceDescriptionWithLocale:string]];
}
-(NSString *)BKReplaceDescriptionWithLocale:(NSString *)string indent:(NSUInteger)level
{
    return [NSObject BKStringByReplaceUnicodeString:[self BKReplaceDescriptionWithLocale:string indent:level]];
}

@end
