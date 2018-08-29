//
//  AppBaseView.m
//  APPTool
//
//  Created by liu gangyi on 2018/8/20.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "AppBaseView.h"

@implementation AppBaseView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    while ([self nextResponder]) {
        NSLog(@"%@" , [self nextResponder] ); 
    }
    
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {

    
    return YES;
}

@end
