//
//  AppBatchRequest.m
//  APPTool
//
//  Created by liugangyi on 2018/11/14.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "AppBatchRequest.h"
#import "AppBaseRequest.h"

@implementation AppBatchRequest
{
    NSMutableArray <AppBaseRequest *> * _requestRecorder;
    NSUInteger _finishedCount;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestRecorder = [NSMutableArray array];
        _finishedCount = 0;
    }
    return self;
}

- (instancetype)initWithRequestArray:(NSArray<AppBaseRequest *> *)requestArray {
    self = [self init];
    if (self) {
        [_requestRecorder addObjectsFromArray:requestArray];
    }
    return self;
}

- (void)setCompleteBlockWithSuccess:(void (^)(AppBatchRequest *))success
                           failured:(void (^)(AppBatchRequest *, AppBaseRequest *))failured {
    self.successCompleteBlock = success;
    self.failuredCompleteBlock = failured;
}

- (void)startCompleteBlockWithSuccess:(void (^)(AppBatchRequest *))success
                             failured:(void (^)(AppBatchRequest *, AppBaseRequest *))failured {
    [self setCompleteBlockWithSuccess:success failured:failured];
    [self start];
}

- (void)start {
    if (_finishedCount > 0) {
        return;
    }
    for (AppBaseRequest *request in _requestRecorder) {
        [request start];
    }
}

- (void)stop {
    
}

- (void)addRequest:(AppBaseRequest *)request completeWithSuccess:(void (^)(AppBaseRequest *))success failured:(void (^)(AppBaseRequest *))failured {
    [_requestRecorder addObject:request];
    request.successCompletionBlock = success;
    request.failureCompletionBlock = failured;
}

- (void)clearCallBackBlock {
    
}

- (NSMutableArray *)requestArray {
    return _requestRecorder;
}

@end
