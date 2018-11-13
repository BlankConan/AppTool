//
//  AppBaseRequest.h
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 请求方法
 */
typedef NS_ENUM(NSInteger, AppRequestMethod) {
    // get
    AppRequestMethodGet = 1,
    // post
    AppRequestMethodPost,
    // put
    AppRequestMethodPut,
};

/**
 请求序列化
 */
typedef NS_ENUM(NSInteger, AppRequestSerializerType) {
    // http request
    AppRequestSerializerHTTP = 1,
    // JSON request
    AppRequestSerializerJSON,
};

// 构造POST block
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

/**
 请求x回调协议
 */
@class AppBaseRequest;
@protocol AppRequestDelegate <NSObject>

@optional
/**
 进度回调

 @param progress 进度
 @param request 请求
 */
- (void)requestProgress:(NSProgress *)progress request:(AppBaseRequest *)request;

/**
 请求结束

 @param request 当前结束的请求
 */
- (void)requestFinished:(AppBaseRequest *)request;

/**
 请求失败回调

 @param request 当前失败的请求
 */
- (void)requestFailed:(AppBaseRequest *)request;

@end



@interface AppBaseRequest : NSObject

// tag
@property (nonatomic, assign) NSInteger tag;

#pragma mark Request Configure

/// useCDN?.
@property (nonatomic, assign) BOOL useCDN;
/// base -> cdnurl.
@property (nonatomic, strong) NSString *cdnUrl;
/// base -> baseurl.
@property (nonatomic, strong) NSString *baseUrl;
///  request detail url.
@property (nonatomic, strong) NSString *requestUrl;

/// request timeout.
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

/// request arguments.
@property (nonatomic, strong) id requestArguments;
/// request base arguments.
@property (nonatomic, strong) NSDictionary *requestBaseArguments;
/// request method.
@property (nonatomic, assign) AppRequestMethod reqeustMethod;
/// request Serializer type.
@property (nonatomic, assign) AppRequestSerializerType requestSerializerType;

/// header authorization.
@property (nonatomic, copy) NSArray *requestAuthorizationHeaderFieldArray;
/// request header k-v.
@property (nonatomic, strong) NSDictionary *requestHeaderFieldValueDictionary;

@property (nonatomic, copy) AFConstructingBlock constructingBodyBlock;

#pragma mark - response

@property (nonatomic, copy) id responseObject;
@property (nonatomic, copy) NSDictionary *responseHeaders;
@property (nonatomic, assign) NSInteger reponseStatusCode;
@property (nonatomic, strong) NSError *error;


#pragma mark - Request call back
/// delegate.
@property (nonatomic, weak) id<AppRequestDelegate> delegate;
/// success block.
@property (nonatomic, copy) void (^successCompletionBlock)(AppBaseRequest *);
// failure block.
@property (nonatomic, copy) void (^failureCompletionBlock)(AppBaseRequest *);
/// progress block.
@property (nonatomic, copy) void (^progressBlock)(NSProgress *);


/**
 Add self to request queue
 */
- (void)start;

/**
 remove self to request queue
 */
- (void)stop;

/**
 request is excuting

 @return yes or no
 */
- (BOOL)isExcuting;

/**
 请求结束执行回调(自动进行请求)

 @param progress 进度block
 @param success 成功block
 @param failure 失败block
 */
- (void)startCompletionBlockWithProgress:(void (^) (NSProgress *))progress
                                 success:(void (^) (AppBaseRequest *))success
                                 failure:(void (^) (AppBaseRequest *))failure;

/**
 设置回调block

 @param progress 进度回调block
 @param success 成功回调block
 @param failure 失败回调block
 */
- (void)setCompletionBlockWithProgress:(void (^) (NSProgress *))progress
                                 success:(void (^) (AppBaseRequest *))success
                                 failure:(void (^) (AppBaseRequest *))failure;

/**
 清空回调block 打破循环引用
 */
- (void)clearCompletionBlock;

#pragma mark 需要子类重载的方法，用来覆盖默认值

- (void)requestSuccessFilter;

- (void)requestFailureFilter;


// 是否使用CDN
- (void)setUseCDN:(BOOL)useCDN;
- (BOOL)useCDN;

// base cdn url
- (void)setCdnUrl:(NSString * _Nonnull)cdnUrl;
- (NSString * _Nonnull)cdnUrl;

// nomal base url
- (void)setBaseUrl:(NSString * _Nonnull)baseUrl;
- (NSString * _Nonnull)baseUrl;

//  request detail url
- (void)setRequestUrl:(NSString * _Nonnull)requestUrl;
- (NSString * _Nonnull)requestUrl;

// reqeust timeout, default 60s
- (void)setRequestTimeoutInterval:(NSTimeInterval)requestTimeoutInterval;
- (NSTimeInterval)requestTimeoutInterval;

// public arguments
- (NSDictionary * _Nonnull)requestBaseArguments;

// request arguments
- (void)setRequestArguments:(id _Nonnull)requestArguments;
- (id _Nonnull)requestArguments;

// auth header list
- (void)setRequestAuthorizationHeaderFieldArray:(NSArray * _Nonnull)requestAuthorizationHeaderFieldArray;
- (NSArray * _Nonnull)requestAuthorizationHeaderFieldArray;

// request header K-V
- (void)setRequestHeaderFieldValueDictionary:(NSDictionary * _Nonnull)requestHeaderFieldValueDictionary;
- (NSDictionary * _Nonnull)requestHeaderFieldValueDictionary;

#warning liugangyi 需要修改
/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock;

@end
