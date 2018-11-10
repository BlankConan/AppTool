//
//  AppTimer.h
//  APPTool
//
//  Created by liu gangyi on 2018/9/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTimer : NSObject

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)time
                               target:(nonnull id)target
                             selector:(nonnull SEL)selector
                             userInfo:(nullable id)userInfo
                              repeats:(BOOL)repeat;


- (void)fire;

- (void)stop;

/**
 一定要调用这个方法，进行释放
 */
- (void)invalidate;

@end
