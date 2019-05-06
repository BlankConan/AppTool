//
//  BKChainRequest.h
//  APPTool
//
//  Created by liugangyi on 2018/11/16.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class BKChainRequest;

/// chain requset protocol.
@protocol BKChainRequestDelegate <NSObject>

/**
 有序组请求成功

 @param chainReqeust chainReqeust
 */
- (void)chainRequestSucess:(BKChainRequest *)chainReqeust;

/**
 有序组请求请求失败

 @param chainRequest chainRequest
 */
- (void)chainRequestFailured:(BKChainRequest *)chainRequest failuredRequest:(BKBaseRequest *)request;

@end


/**
 每个请求的回调block定义

 @param chainRequset 当前 chain
 @param request request
 */
typedef void(^ChainRequestCallBack)(BKChainRequest *chainRequset, BKBaseRequest *request);


@interface BKChainRequest : NSObject
/// 代理.
@property (nonatomic, weak) id<BKChainRequestDelegate> delegate;
/// 成功回调block.
@property (nonatomic, copy) void (^completeSuccess)(BKChainRequest *);
/// 失败回调block.
@property (nonatomic, copy) void (^completeFailured)(BKChainRequest *, BKBaseRequest *);

/// 开始.
- (void)start;

/// 停止请求.
- (void)stop;


/**
 设置回调block

 @param sucessed 成功回调
 @param failured 失败回调
 */
- (void)setCompleteBlockWithSuccess:(void (^)(BKChainRequest *chainRequest))sucessed
                           failured:(void (^)(BKChainRequest *chainRequest, BKBaseRequest *request))failured;


/**
 添加请求

 @param baseRequest baseRequest instance
 @param callBack 回调block
 */
- (void)addRequset:(BKBaseRequest *)baseRequest callBack:(nullable ChainRequestCallBack)callBack;


/**
 开启组请求并回调

 @param sucessed 成功回调
 @param failured 失败回调
 */
- (void)startRequestWithCompleteBlockSucess:(void (^)(BKChainRequest *chainRequest))sucessed
                                   failured:(void (^)(BKChainRequest *chainRequest, BKBaseRequest *request))failured;

/// 存储所有的请求.
- (NSArray<BKBaseRequest *> *)requestArray;

@end

NS_ASSUME_NONNULL_END
