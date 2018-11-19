//
//  BKTimer.m
//  APPTool
//
//  Created by liu gangyi on 2018/9/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKTimer.h"
#import <objc/message.h>

@interface BKTimer()
{
    @private
    __weak id _target;
    SEL _sel;
    id _userInfo;
    BOOL _repeat;
    NSTimeInterval _timerInterval;
    NSDate * _internalFireDate;
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BKTimer
@synthesize fireDate;


- (instancetype)init {
    self = [super init];
    if (self) {
        _timerInterval = 1.0;
        _target = nil;
        _sel = nil;
        _userInfo = nil;
        _repeat = NO;
        _internalFireDate = [NSDate date];
    }
    return self;
}

#pragma mark - Public Method

- (id)userInfo {
    return _userInfo;
}

- (void)setFireDate:(NSDate *)fireDate {
    _internalFireDate = [fireDate copy];
    _timer.fireDate = _internalFireDate;
}

- (NSDate *)fireDate {
    return _internalFireDate;
}

- (NSTimeInterval)timeInterval {
    return _timerInterval;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)time target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeat {
    
    BKTimer *appTimer = [[BKTimer alloc] init];
    appTimer->_target = target;
    appTimer->_sel = selector;
    appTimer->_timerInterval= time;
    appTimer->_userInfo = userInfo;
    appTimer->_repeat = repeat;
    [appTimer createTimer];

    return appTimer;
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
    [self invalidate];
}

- (void)invalidate {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark - Assistant method

/// timer action.
- (void)timerAction {
    
    if (self->_target != nil && [self->_target respondsToSelector:self->_sel]) {
        objc_msgSend(self->_target, self->_sel, self->_userInfo);
    }
}

/// create timer.
- (void)createTimer {
    
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:self->_timerInterval target:self selector:@selector(timerAction) userInfo:self->_userInfo repeats:self->_repeat];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)dealloc {
    NSLog(@"释放了 %@", self.class);
}

@end
