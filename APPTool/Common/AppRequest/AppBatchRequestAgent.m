//
//  AppBatchRequestAgent.m
//  APPTool
//
//  Created by liugangyi on 2018/11/14.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "AppBatchRequestAgent.h"

static dispatch_semaphore_t lock;

@implementation AppBatchRequestAgent {
    NSMutableArray <AppBatchRequest *> * _requestArray;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
        lock = dispatch_semaphore_create(1);
    }
    return self;
}

+ (instancetype)shareInstance {
    static id agent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[AppBatchRequestAgent alloc] init];
    });
    return agent;
}

- (void)addBatchRequest:(AppBatchRequest *)request {
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [_requestArray addObject:request];
    dispatch_semaphore_signal(lock);
}

- (void)removeBatchRequest:(AppBatchRequest *)request {
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [_requestArray removeObject:request];
    dispatch_semaphore_signal(lock);
}

@end
