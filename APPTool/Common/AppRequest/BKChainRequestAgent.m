//
//  BKChainRequestAgent.m
//  APPTool
//
//  Created by liugangyi on 2018/11/16.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKChainRequestAgent.h"

static dispatch_semaphore_t sema;

@implementation BKChainRequestAgent {
    NSMutableArray *_requestArray;
}

#pragma mark - Init
- (instancetype)init {
    self = [super init];
    if (self) {
        sema = dispatch_semaphore_create(1);
        _requestArray = [NSMutableArray array];
    }
    return self;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

#pragma mark - Public

+ (instancetype)shareInstance {
    static id agent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[self alloc] init];
    });
    return agent;
}

- (void)addChainRequest:(BKChainRequest *)request {
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [_requestArray addObject:request];
    dispatch_semaphore_signal(sema);
}

- (void)removeChainRequest:(BKChainRequest *)request {
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [_requestArray removeObject:request];
    dispatch_semaphore_signal(sema);
}

@end
