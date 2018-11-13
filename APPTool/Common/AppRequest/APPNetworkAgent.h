//
//  APPNetworkAgent.h
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppBaseRequest;
NS_ASSUME_NONNULL_BEGIN

/**
 请求管理类
 */
@interface APPNetworkAgent : NSObject

/**
 单例创建

 @return 返回单例
 */
+ (instancetype)shareInstance;

/**
 添加请求

 @param request 请求子类
 */
- (void)addRequest:(AppBaseRequest *)request;

/**
 取消请求

 @param request 请求子类
 */
- (void)cancelRequest:(AppBaseRequest *)request;

/**
 取消所有请求
 */
- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
