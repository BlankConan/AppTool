//
//  BKChainRequestAgent.h
//  APPTool
//
//  Created by liugangyi on 2018/11/16.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKChainRequest;

NS_ASSUME_NONNULL_BEGIN

@interface BKChainRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 创建单例.
+ (instancetype)shareInstance;


/**
 添加 chain request 到 queue

 @param request Chain request
 */
- (void)addChainRequest:(BKChainRequest *)request;

/**
 从 queue 中移除队列

 @param request Chain request
 */
- (void)removeChainRequest:(BKChainRequest *)request;

@end

NS_ASSUME_NONNULL_END
