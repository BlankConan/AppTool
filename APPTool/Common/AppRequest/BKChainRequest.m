//
//  BKChainRequest.m
//  APPTool
//
//  Created by liugangyi on 2018/11/16.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKChainRequest.h"
#import "BKChainRequestAgent.h"
@interface BKChainRequest ()<BKRequestDelegate>

@property (nonatomic, strong) NSMutableArray<BKBaseRequest *> *requestArr;
@property (nonatomic, strong) NSMutableArray<ChainRequestCallBack> *requestCallBackArray;
@property (nonatomic, assign) NSUInteger nextRequestIndex;
@property (nonatomic, strong) ChainRequestCallBack emptyCallBack;
@end

@implementation BKChainRequest

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nextRequestIndex = 0;
        _requestArr = [NSMutableArray array];
        _requestCallBackArray = [NSMutableArray array];
        _emptyCallBack = ^(BKChainRequest *chainRequest, BKBaseRequest *baseRequest) {
            // do nothing
        };
    }
    return self;
}

#pragma mark - Public method

- (NSArray<BKBaseRequest *> *)requestArray {
    return _requestArr;
}

- (void)start {
    
    if (_nextRequestIndex > 0) {
        debugLog(@"Error! Chain request has started");
        return;
    }
    
    if (_requestArr.count) {
        [self startNextRequest];
         [[BKChainRequestAgent shareInstance] addChainRequest:self];
    } else {
        debugLog(@"Error! Chain request is empty");
    }
    
}

- (void)stop {
    [self clearRequest];
    [[BKChainRequestAgent shareInstance] removeChainRequest:self];
}

- (void)addRequest:(BKBaseRequest *)baseRequest callBack:(nullable ChainRequestCallBack)callBack {
    
    [_requestArr addObject:baseRequest];
    if (callBack) {
        [_requestCallBackArray addObject:callBack];
    } else {
        [_requestCallBackArray addObject:_emptyCallBack];
    }
}

- (void)startRequestWithCompleteBlockSucess:(void (^)(BKChainRequest * _Nonnull))sucessed
                                   failured:(void (^)(BKChainRequest * _Nonnull, BKBaseRequest * _Nonnull))failured {
    [self setCompleteBlockWithSuccess:sucessed failured:failured];
    
}

- (void)setCompleteBlockWithSuccess:(void (^)(BKChainRequest * _Nonnull))sucessed
                           failured:(void (^)(BKChainRequest * _Nonnull, BKBaseRequest * _Nonnull))failured {
    self.completeSuccess = sucessed;
    self.completeFailured = failured;
}

#pragma mark BaseRequest Delegate

- (void)requestFinished:(BKBaseRequest *)request {
    
    NSUInteger currentRequestIndex = _nextRequestIndex;
    ChainRequestCallBack callback = _requestCallBackArray[currentRequestIndex];
    callback(self,request);
    callback = nil;
    _nextRequestIndex++;
    
    if (![self startNextRequest]) {
        if (_delegate && [_delegate respondsToSelector:@selector(chainRequestSucess:)]) {
            [_delegate chainRequestSucess:self];
        }
        [[BKChainRequestAgent shareInstance] removeChainRequest:self];
    }
}

- (void)requestFailured:(BKBaseRequest *)request {
    if (_delegate && [_delegate respondsToSelector:@selector(chainRequestFailured:failuredRequest:)]) {
        [_delegate chainRequestFailured:self failuredRequest:request];
    }
    if (_completeFailured) {
        _completeFailured(self, request);
    }
    [[BKChainRequestAgent shareInstance] removeChainRequest:self];
}

#pragma mark - Assistant method

- (BOOL)startNextRequest {
    if (_nextRequestIndex < [_requestArr count]) {
        BKBaseRequest *request = _requestArr[_nextRequestIndex];
        request.delegate = self;
        [request clearCompletionBlock];
        [request start];
        return YES;
    }
    return NO;
}

- (void)clearRequest {
    NSUInteger currentRequestIndex = _nextRequestIndex;
    if (currentRequestIndex < [_requestArr count]) {
        BKBaseRequest *request = _requestArr[currentRequestIndex];
        [request stop];
    }
    [_requestArr removeAllObjects];
    [_requestCallBackArray removeAllObjects];
}


@end

