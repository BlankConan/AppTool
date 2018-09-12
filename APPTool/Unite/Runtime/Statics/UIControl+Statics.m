//
//  UIControl+Statics.m
//  APPTool
//
//  Created by liu gangyi on 2018/7/27.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "UIControl+Statics.h"
#import <objc/runtime.h>
@implementation UIControl (Statics)

- (void)setInfo:(id)info {
    objc_setAssociatedObject(self, _cmd, info, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)info {
    return objc_getAssociatedObject(self, _cmd);
}

@end
