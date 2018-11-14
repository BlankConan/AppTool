//
//  AppBaseRequest.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "AppBaseRequest.h"
#import "APPNetworkAgent.h"
@implementation AppBaseRequest

#pragma mark Initialize

- (instancetype)init {
    self = [super init];
    if (self) {
        _useCDN = NO;
        _cdnUrl = @"";
        _baseUrl = @"";
        _requestUrl = @"";
        _reqeustMethod = AppRequestMethodGet;
        _requestTimeoutInterval = 60;
        _requestSerializerType = AppRequestSerializerHTTP;
    }
    return self;
}


- (void)start {
    [[APPNetworkAgent shareInstance] addRequest:self];
}

- (void)stop {
    self.delegate = nil;
    [[APPNetworkAgent shareInstance] cancelRequest:self];
}

- (BOOL)isExcuting {
    return true;
//    return self.task.state == NSURLSessionTaskStateRunning;
}

- (void)startCompletionBlockWithProgress:(void (^)(NSProgress * _Nonnull))progress
                                 success:(void (^)(AppBaseRequest * _Nonnull))success
                                 failure:(void (^)(AppBaseRequest * _Nonnull))failure {
    [self setCompletionBlockWithProgress:progress success:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithProgress:(void (^)(NSProgress * _Nonnull))progress
                               success:(void (^)(AppBaseRequest * _Nonnull))success
                               failure:(void (^)(AppBaseRequest * _Nonnull))failure {
    self.progressBlock = progress;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    if (self.progressBlock) self.progressBlock = nil;
    if (self.successCompletionBlock) self.successCompletionBlock = nil;
    if (self.failureCompletionBlock) self.failureCompletionBlock = nil;
}

- (NSDictionary *)responseHeaders {
    return nil;
}

- (NSInteger)reponseStatusCode {
    return 0;
}

#pragma mark - subclass need override

- (void)requestSuccessFilter {}

- (void)requestFailureFilter {}

- (NSString *)cdnUrl {
    return _cdnUrl;
}

- (NSString *)baseUrl {
    return _baseUrl;
}

- (NSString *)requestUrl {
    return _requestUrl;
}

- (NSTimeInterval)requestTimeoutInterval {
    return _requestTimeoutInterval;
}

- (AppRequestSerializerType)requestSerializerType {
    return _requestSerializerType;
}

- (NSDictionary *)requestBaseArguments {
    return _requestBaseArguments;
}

- (id)requestArguments {
    return _requestArguments;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return _requestHeaderFieldValueDictionary;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return _requestAuthorizationHeaderFieldArray;
}

- (BOOL)useCDN {
    return _useCDN;
}

- (void)setConstructingBodyBlock:(AFConstructingBlock)constructingBodyBlock {
    _constructingBodyBlock = constructingBodyBlock;
}

#pragma mark Private



@end
