//
//  BKBatchRequest.m
//  APPTool
//
//  Created by liugangyi on 2018/11/14.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKBatchRequest.h"
#import "BKBatchRequestAgent.h"
#import "BKRequest.h"

@interface BKBatchRequest() <BKRequestDelegate>

@property (nonatomic) NSInteger finishedCount;
@property (nonatomic, strong) NSMutableArray<BKRequest *> *requestRecorder;
@end

@implementation BKBatchRequest

#pragma mark - Public method

- (instancetype)initWithRequestArray:(NSArray<BKRequest *> *)requestArray {
    self = [super init];
    if (self) {
        _finishedCount = 0;
        _requestRecorder = [requestArray mutableCopy];
        for (BKRequest *reqest in _requestRecorder) {
            if (![reqest isKindOfClass:[BKRequest class]]) {
                debugLog(@"Error, item must be Appreqeust instance");
                return nil;
            }
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _finishedCount = 0;
        _requestRecorder = [NSMutableArray array];
    }
    return self;
}

- (void)setCompleteBlockWithSuccess:(void (^)(BKBatchRequest *))success
                           failured:(void (^)(BKBatchRequest *, BKRequest *))failured {
    self.successCompleteBlock = success;
    self.failuredCompleteBlock = failured;
}

- (void)startCompleteBlockWithSuccess:(void (^)(BKBatchRequest *))success
                             failured:(void (^)(BKBatchRequest *, BKRequest *))failured {
    [self setCompleteBlockWithSuccess:success failured:failured];
    [self start];
}


- (void)addRequest:(BKRequest *)request
completeWithSuccess:(void (^)(BKRequest *baseRequest))success
          failured:(void (^)(BKRequest *baseRequest))failured {
    
    [_requestRecorder addObject:request];
    request.successCompletionBlock = (void(^)(BKBaseRequest *))success;
    request.failureCompletionBlock = (void(^)(BKBaseRequest *))failured;
}

- (void)start {
    if (_finishedCount > 0) {
        return;
    }
    [[BKBatchRequestAgent shareInstance] addBatchRequest:self];
    for (BKRequest *request in _requestRecorder) {
        request.delegate = self;
        // start each item request
        [request start];
    }
}

- (void)stop {
    [self clearRequest];
    [[BKBatchRequestAgent shareInstance] removeBatchRequest:self];
}


- (void)clearCompletionBlock {
    self.successCompleteBlock = nil;
    self.failuredCompleteBlock = nil;
}


- (NSMutableArray *)requestArray {
    return _requestRecorder;
}

#pragma mark - AppRequest Delegate

- (void)requestProgress:(NSProgress *)progress request:(BKBaseRequest *)request {}

- (void)requestFinished:(BKBaseRequest *)request {
    _finishedCount++;
    // 判断所有的请求是否都走完了
    if (_requestRecorder.count == _finishedCount) {
        
        if (_successCompleteBlock) {
            _successCompleteBlock(self);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(batchRequestSuccessed:)]) {
            [_delegate batchRequestSuccessed:self];
        }
        
        [self clearCompletionBlock];
    }
}

- (void)requestFailured:(BKBaseRequest *)request {
    _failedRequest = (BKRequest *)request;
 
    if (_delegate && [_delegate respondsToSelector:@selector(batchRequestFailured:failuredReqeust:)]) {
        [_delegate batchRequestFailured:self failuredReqeust:_failedRequest];
    }

    if (_failuredCompleteBlock) {
        self.failuredCompleteBlock(self, _failedRequest);
    }
    
    [self clearRequest];
}


#pragma mark - Private

- (void)clearRequest {
    self.delegate = nil;
    for (BKRequest *request in _requestRecorder) {
        [request stop];
    }
    [self clearCompletionBlock];
}


@end
