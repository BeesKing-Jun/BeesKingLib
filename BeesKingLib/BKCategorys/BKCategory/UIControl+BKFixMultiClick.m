//
//  UIControl+BKFixMultiClick.m
//  BeesKingLib
//
//  Created by WJ on 2020/3/9.
//  Copyright © 2020年 BeesKingLib. All rights reserved.
//

#import "UIControl+BKFixMultiClick.h"
#import <objc/runtime.h>

@interface UIControl ()
/**上一次点击时间戳*/
@property (nonatomic, assign) NSTimeInterval BKAcceptEventTime;

@end


@implementation UIControl (BKFixMultiClick)

+ (void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method customMethod = class_getInstanceMethod(self, @selector(BKSendAction:to:forEvent:));
    SEL customSEL = @selector(BKSendAction:to:forEvent:);
    
    //添加方法 语法：BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types) 若添加成功则返回No
    // cls：被添加方法的类  name：被添加方法方法名  imp：被添加方法的实现函数  types：被添加方法的实现函数的返回值类型和参数类型的字符串
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(customMethod), method_getTypeEncoding(customMethod));
    
    //如果系统中该方法已经存在了，则替换系统的方法  语法：IMP class_replaceMethod(Class cls, SEL name, IMP imp,const char *types)
    if (didAddMethod) {
        class_replaceMethod(self, customSEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, customMethod);
    }
}

- (NSTimeInterval )BKAcceptEventInterval{
    return [objc_getAssociatedObject(self, "UIControl_BKAcceptEventInterval") doubleValue];
}

- (void)setBKAcceptEventInterval:(NSTimeInterval)BKAcceptEventInterval {
    objc_setAssociatedObject(self, "UIControl_BKAcceptEventInterval", @(BKAcceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )BKAcceptEventTime{
    return [objc_getAssociatedObject(self, "UIControl_BKAcceptEventTime") doubleValue];
}

- (void)setBKAcceptEventTime:(NSTimeInterval)BKAcceptEventTime {
    objc_setAssociatedObject(self, "UIControl_BKAcceptEventTime", @(BKAcceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)BKSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    // 如果想要设置统一的间隔时间，可以在此处加上以下几句
    // 值得提醒一下：如果这里设置了统一的时间间隔，会影响UISwitch,如果想统一设置，又不想影响UISwitch，建议将UIControl分类，改成UIButton分类，实现方法是一样的
    // if (self.BKAcceptEventTime <= 0) {
    //     // 如果没有自定义时间间隔，则默认为2秒
    //    self.BKAcceptEventTime = 2;
    // }
    
    // 是否小于设定的时间间隔
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.BKAcceptEventTime >= self.BKAcceptEventInterval);
    
    // 更新上一次点击时间戳
    if (self.BKAcceptEventInterval > 0) {
        self.BKAcceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    // 两次点击的时间间隔小于设定的时间间隔时，才执行响应事件
    if (needSendAction) {
        [self BKSendAction:action to:target forEvent:event];
    }
}

@end

