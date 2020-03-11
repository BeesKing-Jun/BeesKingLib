//
//  NSObject+BKCatchException.m
//  BeesKingLib
//
//  Created by WJ on 2020/3/11.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//

#define BKCrashSeparator         @"================================================================"
#define BKCrashSeparatorWithFlag @"========================BKCatchCrash Log=========================="
#define BKKey_errorName        @"errorName"
#define BKKey_errorReason      @"errorReason"
#define BKKey_errorPlace       @"errorPlace"
#define BKKey_defaultToDo      @"defaultToDo"
#define BKKey_callStackSymbols @"callStackSymbols"
#define BKKey_exception        @"exception"
#define BKCrashNotification    @"BKCrashNotification"

#import "NSObject+BKCatchException.h"

@implementation NSObject (BKCatchException)

/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbols 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */

+ (NSString *)BKGetMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                    
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}


/**
 *  提示崩溃的信息(控制台输出、通知)
 *
 *  @param exception   捕获到的异常
 *  @param defaultToDo 这个框架里默认的做法
 */
+ (void)BKNoteErrorWithException:(NSException *)exception defaultToDo:(NSString *)defaultToDo {
    
    //堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    
    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名]
    NSString *mainCallStackSymbolMsg = [self BKGetMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    
    if (mainCallStackSymbolMsg == nil) {
        
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
        
    }
    
    NSString *errorName = exception.name;
    NSString *errorReason = exception.reason;
    //errorReason 可能为 -[__NSCFConstantString avoidCrashCharacterAtIndex:]: Range or index out of bounds
    //将avoidCrash去掉
    errorReason = [errorReason stringByReplacingOccurrencesOfString:@"aaaavoidCrash" withString:@""];
    
    NSString *errorPlace = [NSString stringWithFormat:@"Error Place:%@",mainCallStackSymbolMsg];
    
    NSString *logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n\n%@\n%@\n%@\n%@\n\n%@\n\n",BKCrashSeparatorWithFlag, errorName, errorReason, errorPlace, defaultToDo, BKCrashSeparator];
    NSLog(@"%@", logErrorMessage);
    
    NSDictionary *errorInfoDic = @{
                                   BKKey_errorName        : errorName,
                                   BKKey_errorReason      : errorReason,
                                   BKKey_errorPlace       : errorPlace,
                                   BKKey_defaultToDo      : defaultToDo,
                                   BKKey_exception        : exception,
                                   BKKey_callStackSymbols : callStackSymbolsArr
                                   };
    
    //将错误信息放在字典里，用通知的形式发送出去
    [[NSNotificationCenter defaultCenter] postNotificationName:BKCrashNotification object:nil userInfo:errorInfoDic];
}

@end
