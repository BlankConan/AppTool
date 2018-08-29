//
//  UIView+UIResponder.m
//  APPTool
//
//  Created by liu gangyi on 2018/8/21.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "UIView+UIResponder.h"
#import <objc/runtime.h>



/**
 用来替换方法

 @param cls 需要替换方法的类名
 @param originalSelector 原方法SEL
 @param swizzlingSelector 替换方法SEL
 */
static inline void swizzling_Method(Class cls, SEL originalSelector, SEL swizzlingSelector) {
    
    Method originalMethod = nil;
    Method swizzlingMethod = nil;
    if (class_isMetaClass(cls)) {
        originalMethod = class_getClassMethod(cls, originalSelector);
        swizzlingMethod = class_getClassMethod(cls, swizzlingSelector);
    } else {
        originalMethod = class_getInstanceMethod(cls, originalSelector);
        swizzlingMethod = class_getInstanceMethod(cls, swizzlingSelector);
    }
    
    BOOL success = class_addMethod(cls, originalSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
    if (success) {
        class_replaceMethod(cls, swizzlingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzlingMethod);
    }
}


@implementation UIView (UIResponder)


+ (void)load {
    
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//}
//
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//}



@end
