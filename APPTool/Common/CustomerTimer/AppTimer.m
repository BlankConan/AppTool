//
//  AppTimer.m
//  APPTool
//
//  Created by liu gangyi on 2018/9/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "AppTimer.h"
#import <objc/message.h>

@interface AppTimer()
{
    @private
    __weak id target;
    SEL sel;
    id userInfo;
    BOOL repeat;
    NSTimeInterval time;
}
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AppTimer

- (instancetype)init {
    self = [super init];
    if (self) {
        time = 1.0;
        target = nil;
        sel = nil;
        userInfo = nil;
        repeat = NO;
    }
    return self;
}


+ (instancetype)timerWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeat {
    
    AppTimer *appTimer = [[AppTimer alloc] init];
    appTimer->target = target;
    appTimer->sel = selector;
    appTimer->time = time;
    appTimer->userInfo = userInfo;
    appTimer->repeat = repeat;
    [appTimer createTimer];

    return appTimer;
}


- (void)timerAction {
    
    if (self->target != nil && [self->target respondsToSelector:self->sel]) {
        objc_msgSend(self->target, self->sel, self->userInfo);
    }
}

- (void)fire {
    if (_timer) {
        [_timer fire];
    } else {
        [self createTimer];
        [_timer fire];
    }
}

- (void)stop {
    [_timer invalidate];
}

- (void)invalidate {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)createTimer {
    
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:self->time target:self selector:@selector(timerAction) userInfo:self->userInfo repeats:self->repeat];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)dealloc {
    NSLog(@"释放了 %@", self.class);
}

@end
