//
//  BKNetworkAgent.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKNetworkAgent.h"
#import "BKRequest.h"
#import "PGRequestResponseCheck.h"

static dispatch_semaphore_t sema;

@implementation BKNetworkAgent {
    AFHTTPSessionManager *_manager;
    // 通过request hash 找 task
    NSMutableDictionary *_requestTaskRecorder;
}


#pragma mark Public

+ (instancetype)shareInstance {
    static id agent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [[self alloc] init];
        sema = dispatch_semaphore_create(1);
        [agent initNetworkManager];
    });
    return agent;
}

/**
 构造afn请求参数

 @param request request
 */
- (void)addRequest:(BKBaseRequest *)request {
    
    NSString *url = [self buildRequestUrlStr:request];
    
    id requestArguments = [request requestArguments];
    
    NSDictionary *baseArguments = [request requestBaseArguments];
    if (baseArguments == nil) {
        baseArguments = [NSDictionary dictionary];
    }
    NSMutableDictionary *arguments = [baseArguments mutableCopy];
    [arguments setValuesForKeysWithDictionary:requestArguments];
    if (arguments.allKeys.count == 0) arguments = nil;
    // 看接口是否需要包一层
//    BKRequestMethod method = [request requestMethod];
//    if (method == BKRequestMethodGet && arguments) {
//        NSData *data = [NSJSONSerialization dataWithJSONObject:arguments options:NSJSONWritingPrettyPrinted error:nil];
//        arguments = [NSMutableDictionary dictionaryWithObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:@"queryJson"];
//    }
    [self request:request url:url parameter:arguments];
}

- (void)cancelRequest:(BKBaseRequest *)request {
    
    [request.task cancel];
    [request clearCompletionBlock];
    [self removeOperation:request];
}

- (void)cancelAllRequest {
    NSArray *allReqeust = [_requestTaskRecorder allValues];
    for (BKBaseRequest *request in allReqeust) {
        [self cancelRequest:request];
    }
}

#pragma mark ------------ Private -----------

#pragma mark 初始化
- (instancetype)init {
    
    self = [super init];
    if (self) {
        NSAssert(YES, @"请使用单例创建");
    }
    return self;
}

- (void)initNetworkManager {
    
    // 请求超时设置
    // 1. 可以通过 configuration，设置所有的超时时间
    // 2. 通过 RequestSerializer，设置超时时间s
    _manager = [AFHTTPSessionManager manager];
    _manager.operationQueue.maxConcurrentOperationCount = 10;
    // 创建新的 返回数据解析类型
    NSMutableSet *contentTypeSet = [[[_manager responseSerializer] acceptableContentTypes] mutableCopy];
    [contentTypeSet addObject:@"text/html"];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithSet:contentTypeSet];
    
    //    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    //    policy.validatesDomainName = YES;
    //    _manager.securityPolicy = policy;
    _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    _requestTaskRecorder = [NSMutableDictionary dictionaryWithCapacity:0];
}

#pragma mark Handle Request

/**
 根据request生成请求urlString
 
 @param request 请求子类
 @return 生成url
 */
- (NSString *)buildRequestUrlStr:(BKBaseRequest *)request {
    
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"https://"] ||
        [detailUrl hasPrefix:@"http://"]) {
        return detailUrl;
    }
    
    NSString *baseUrlStr = @"";
    if ([request useCDN]) {
        baseUrlStr = [request cdnUrl];
    } else {
        baseUrlStr = [request baseUrl];
    }
    
    NSString *buildUrl = [baseUrlStr stringByAppendingPathComponent:detailUrl];
    return buildUrl;
}


/**
 构造nfn请求参数，使用afn请求

 @param request request
 @param urlStr urlStr
 @param params 参数
 */
- (void)request:(BKBaseRequest *)request url:(NSString *)urlStr parameter:(id)params {
    
    BKRequestMethod method = [request requestMethod];
    
    // request Serializer configure
    // 1. create serializer
    if (request.requestSerializerType == BKRequestSerializerHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == BKRequestSerializerJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    // 2. set timeout
    _manager.requestSerializer.timeoutInterval = request.requestTimeoutInterval;
    
    // 3. set server username and password
    NSArray *userKeyPair = [request requestAuthorizationHeaderFieldArray];
    [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)userKeyPair.firstObject
                                                               password:(NSString *)userKeyPair.lastObject];
    
    // 4. set header
    NSDictionary *headersDic = [request requestHeaderFieldValueDictionary];
    
    for (NSString *key in headersDic.allKeys) {
        NSString *value = headersDic[key];
        [_manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }
 
    if (method == BKRequestMethodGet) {
        request.task = [_manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            [self handleRequestProgress:downloadProgress request:request];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponceWithTask:task responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleResponceWithTask:task responseObject:nil error:error];
        }];
    } else if (method == BKRequestMethodPost) {
        
        if (request.constructingBodyBlock == nil) {
            request.task = [_manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleRequestProgress:uploadProgress request:request];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponceWithTask:task responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponceWithTask:task responseObject:nil error:error];
            }];
        } else {
            
            request.task = [_manager POST:urlStr parameters:params constructingBodyWithBlock:request.constructingBodyBlock progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleRequestProgress:uploadProgress request:request];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponceWithTask:task responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponceWithTask:task responseObject:nil error:error];
            }];
        }
        
    } else if (method == BKRequestMethodPut) {
        request.task = [_manager PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponceWithTask:task responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleResponceWithTask:task responseObject:nil error:error];
        }];
    } else {
        // Delete
        return;
    }
    
    [self addOperationWithRequest:request];
    
}

/**
 请求完毕回调赋值

 @param task 执行结束的任务
 @param responseObject 回调数据
 @param error 回调错误
 */
- (void)handleResponceWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error {
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSString *key = [self taskHashKey:task];
    BKBaseRequest *request = _requestTaskRecorder[key];
    if (request) {
        request.responseHeaders = response.allHeaderFields;
        request.reponseStatusCode = response.statusCode;
        request.error = error;
        request.responseObject = responseObject;
        // http状态码判断
        if ([self statusCodeValidator:response.statusCode]) {
            
            NSInteger code = -1;
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                code = [[responseObject valueForKey:@"code"] integerValue];
            }
            if (code == 0) {
                // 自动数据解析
                [request requestSuccessFilter];
                // 先执行block回调
                if (request.successCompletionBlock) {
                    // 成功回调
                    request.successCompletionBlock(request);
                }
                
            } else {
                // 处理异常 code
                if (request.exceptCodeBlock) {
                    request.exceptCodeBlock(code,[NSString stringWithFormat:@"%@", [responseObject valueForKey:@"msg"]]);
                } else {
                    [PGRequestResponseCheck checkResponse:responseObject];
                }
            }
            
            // 再执行代理回调
            if (request.delegate && [request.delegate respondsToSelector:@selector(requestFinished:)]) {
                [request.delegate requestFinished:request];
            }
            
        } else {
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            
            if (request.delegate && [request.delegate respondsToSelector:@selector(requestFailured:)]) {
                [request.delegate requestFailured:request];
            }
        }
        [request clearCompletionBlock];
        [self removeOperation:request];
    }
   
}


- (void)handleRequestProgress:(NSProgress *)progress request:(BKBaseRequest *)request {
    
    if (request.progressBlock) {
        request.progressBlock(progress);
    }
    if (request.delegate) {
        [request.delegate requestProgress:progress request:request];
    }
}

#pragma mark - Request Task Record

- (NSString *)taskHashKey:(NSURLSessionDataTask *)task {
    
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[task hash]];
    return key;
}

- (void)addOperationWithRequest:(BKBaseRequest *)request {
    
    NSString *key = [self taskHashKey:request.task];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    _requestTaskRecorder[key] = request;
    dispatch_semaphore_signal(sema);
}

- (void)removeOperation:(BKBaseRequest *)request {
    
    NSString *key = [self taskHashKey:request.task];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    [_requestTaskRecorder removeObjectForKey:key];
    dispatch_semaphore_signal(sema);
}


/// check Status Code
- (BOOL)statusCodeValidator:(NSInteger)code {
    if (code >= 200 && code <= 299) {
        return YES;
    } else {
        return NO;
    }
}


@end
