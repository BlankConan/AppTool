//
//  APPNetworkAgent.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "APPNetworkAgent.h"

@implementation APPNetworkAgent {
    AFHTTPSessionManager * _manager;
    NSMutableDictionary * _requestRecorder;
}


#pragma mark Public

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        [instance initNetworkManager];
    });
    return instance;
}


- (void)addRequest:(AppBaseRequest *)request {
    
    
}

- (void)cancelRequest:(AppBaseRequest *)request {
    
    
}

- (void)cancelAllRequest {
    
}

- (NSString *)buildRequestUrlStr:(AppBaseRequest *)request {
    
    return @"";
}


#pragma mark ------------ Private -----------

#pragma mark 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(YES, @"请使用单例创建");
    }
    return self;
}

- (void)initNetworkManager {

    // 请求超时设置
    // 1. 可以通过configuration，设置所有的超时时间
    // 2. 通过RequestSerializer，设置超时时间s
    _manager = [AFHTTPSessionManager manager];
    _manager.operationQueue.maxConcurrentOperationCount = 10;
//    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//    policy.validatesDomainName = YES;
//    _manager.securityPolicy = policy;
    _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    _requestRecorder = [NSMutableDictionary dictionaryWithCapacity:0];
}




#pragma mark - Request Hash

- (NSString *)requestHashKey:(NSURLSessionDataTask *)task {
    
    NSString *key = [NSString stringWithFormat:@"%lu", [task hash]];
    return key;
}

- (void)addOperation:(AppBaseRequest *)request {
   
}

- (void)removeOpertation:(AppBaseRequest *)request {

}


@end
