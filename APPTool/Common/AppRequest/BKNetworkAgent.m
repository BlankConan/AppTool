//
//  BKNetworkAgent.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKNetworkAgent.h"
#import "BKRequest.h"
static dispatch_semaphore_t sema;

@implementation BKNetworkAgent {
    AFHTTPSessionManager *_manager;
    // 通过request hash 找 task
    NSMutableDictionary *_requestTaskRecorder;
    // 通过 task hash 找 request
    NSMutableDictionary *_taskRequestRecorder;
}


#pragma mark Public

+ (instancetype)shareInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        sema = dispatch_semaphore_create(1);
        [instance initNetworkManager];
    });
    return instance;
}

/**
 构造afn请求参数

 @param request request
 */
- (void)addRequest:(BKBaseRequest *)request {
    
    NSString *url = [self buildRequestUrlStr:request];
    
    id requestArguments = [request requestArguments];
    NSDictionary *baseArguments = [request requestBaseArguments];
    
    NSMutableDictionary *arguments = [baseArguments mutableCopy];
    [arguments setValuesForKeysWithDictionary:requestArguments];
    if (arguments.allKeys.count == 0) arguments = nil;

    BKRequestMethod method = [request reqeustMethod];
    if (method == BKRequestMethodGet && arguments) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:arguments options:NSJSONWritingPrettyPrinted error:nil];
        arguments = [NSMutableDictionary dictionaryWithObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:@"queryJson"];
    }
    [self request:request url:url parameter:arguments];
}

- (void)cancelRequest:(BKBaseRequest *)request {
    [[self taskForRequest:request] cancel];
    [request clearCompletionBlock];
    [self removeOperation:request];
}

- (void)cancelAllRequest {
    NSArray *allReqeust = [_taskRequestRecorder allValues];
    for (BKBaseRequest *request in allReqeust) {
        [request stop];
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
    //    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    //    policy.validatesDomainName = YES;
    //    _manager.securityPolicy = policy;
    _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    
    _requestTaskRecorder = [NSMutableDictionary dictionaryWithCapacity:0];
    _taskRequestRecorder = [NSMutableDictionary dictionaryWithCapacity:0];
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
    
    NSString *buildUrl = [NSString stringWithFormat:@"%@%@", baseUrlStr, detailUrl];
    buildUrl = [buildUrl stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    return buildUrl;
}


/**
 构造nfn请求参数，使用afn请求

 @param request request
 @param urlStr urlStr
 @param params 参数
 */
- (void)request:(BKBaseRequest *)request url:(NSString *)urlStr parameter:(id)params {
    
    BKRequestMethod method = [request reqeustMethod];
    
    // request Serializer configure
    // 1. create serializer
    if (request.requestSerializerType == BKRequestSerializerHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    } else if (request.requestSerializerType == BKRequestSerializerJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
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
 
    
    NSURLSessionDataTask *task = nil;
    if (method == BKRequestMethodGet) {
        task = [_manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            [self handleRequestProgress:downloadProgress request:request];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponceWithTask:task responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleResponceWithTask:task responseObject:nil error:error];
        }];
    } else if (method == BKRequestMethodPost) {
        
        if (request.constructingBodyBlock == nil) {
            task = [_manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleRequestProgress:uploadProgress request:request];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponceWithTask:task responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponceWithTask:task responseObject:nil error:error];
            }];
        } else {
            task = [_manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                // 构造数据
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                [self handleRequestProgress:uploadProgress request:request];
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponceWithTask:task responseObject:responseObject error:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self handleResponceWithTask:task responseObject:nil error:error];
            }];
        }
        
    } else if (method == BKRequestMethodPut) {
        task = [_manager PUT:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self handleResponceWithTask:task responseObject:responseObject error:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self handleResponceWithTask:task responseObject:nil error:error];
        }];
    } else {
        // Delete
        return;
    }
    [self addOperation:request task:task];
    
}

/**
 请求完毕回调赋值

 @param task 执行结束的任务
 @param responseObject 回调数据
 @param error 回调错误
 */
- (void)handleResponceWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error {
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    BKBaseRequest *request = [self requestForTask:task];
    if (request) {
        request.responseHeaders = response.allHeaderFields;
        request.reponseStatusCode = response.statusCode;
        request.error = error;
        
        if ([self statusCodeValidator:response.statusCode]) {
            // 先执行block回调
            if (request.successCompletionBlock) {
                // 自动数据解析
                [request requestSuccessFilter];
                // 成功回调
                request.successCompletionBlock(request);
            }
            // 再执行代理回调
            if (request.delegate) {
                [request.delegate requestFinished:request];
            }
            
        } else {
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            
            if (request.delegate) {
                [request.delegate requestFailed:request];
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

- (NSString *)hashKey:(id<NSObject>)request {
    
    NSString *key = [NSString stringWithFormat:@"%lu", [request hash]];
    return key;
}

- (NSString *)taskHashKey:(NSURLSessionDataTask *)task {
    
    NSString *key = [NSString stringWithFormat:@"%lu", [task hash]];
    return key;
}

- (void)addOperation:(BKBaseRequest *)request task:(NSURLSessionDataTask *)task {
    
    NSString *reqkey = [self hashKey:request];
    NSString *taskKey = [self hashKey:task];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    _requestTaskRecorder[reqkey] = task;
    _taskRequestRecorder[taskKey] = request;
    dispatch_semaphore_signal(sema);
}

- (void)removeOperation:(BKBaseRequest *)request {
    
    NSString *reqkey = [self hashKey:request];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSString *taskKey = [self hashKey:[_requestTaskRecorder objectForKey:reqkey]];
    [_requestTaskRecorder removeObjectForKey:reqkey];
    [_taskRequestRecorder removeObjectForKey:taskKey];
    dispatch_semaphore_signal(sema);
}

- (NSURLSessionDataTask *)taskForRequest:(BKBaseRequest *)request {
    
    NSString *reqkey = [self hashKey:request];
    NSURLSessionDataTask *task = [_requestTaskRecorder objectForKey:reqkey];
    return task;
}

- (BKBaseRequest *)requestForTask:(NSURLSessionDataTask *)task {
    NSString *taskKey = [self hashKey:task];
    BKBaseRequest *request = [_taskRequestRecorder objectForKey:taskKey];
    return request;
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
