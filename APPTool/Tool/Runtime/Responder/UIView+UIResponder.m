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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_Method([UIView class], @selector(touchesBegan:withEvent:), @selector(app_touchesBegan:withEvent:));
        swizzling_Method([UIView class], @selector(touchesMoved:withEvent:), @selector(app_touchesMoved:withEvent:));
        swizzling_Method([UIView class], @selector(touchesEnded:withEvent:), @selector(app_touchesEnded:withEvent:));
        swizzling_Method([UIView class], @selector(touchesCancelled:withEvent:), @selector(app_touchesCancelled:withEvent:));
        swizzling_Method([UIView class], @selector(pointInside:withEvent:), @selector(app_pointInside:withEvent:));
        swizzling_Method([UIView class], @selector(hitTest:withEvent:), @selector(app_hitTest:withEvent:));
    });
}


- (void)app_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    debugLog(@"touch Begin: %@", [self class]);
    UIResponder *next = [self nextResponder];
    while (next) {
        debugLog(@"%@", next.class);
        next = [next nextResponder];
    }
}


- (void)app_touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
//    debugLog(@"touch Move: %@", [self class]);
}

- (void)app_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    debugLog(@"touch Ended: %@", [self class]);
}

- (void)app_touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    debugLog(@"touch Cancelled: %@", [self class]);
}

/** hitTest:withEvent:方法的处理流程如下：
    调用当前view的pointInside:withEvent:方法来判定触摸点是否在当前view内部，
    如果返回NO，则hitTest:withEvent:返回nil；
    如果返回YES，则向当前view内的subViews发送hitTest:withEvent:消息;
    所有subView的遍历顺序是从数组的末尾向前遍历，直到有subView返回非空对象或遍历完成。
    如果有subView返回非空对象，hitTest方法会返回这个对象，如果每个subView返回都是nil，则返回自己
 */
- (nullable UIView *)app_hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) return nil;
    
    if ([self pointInside:point withEvent:event]) {
        for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertPoint = [subView convertPoint:point fromView:self];
            UIView *hitTestView = [subView hitTest:convertPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        debugLog(@"命中的视图%@", self.class);
        return self;
    }
    return nil;
}


- (BOOL)app_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL success = CGRectContainsPoint(self.bounds, point);
    
    success ? debugLog(@"点在%@", [self class]) : debugLog(@"点不在%@", [self class]);
    
    return success;
}


@end
