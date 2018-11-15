//
//  AppBatchRequestAgent.h
//  APPTool
//
//  Created by liugangyi on 2018/11/14.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AppBatchRequest;

@interface AppBatchRequestAgent : NSObject

+ (instancetype)shareInstance;


/**
 Add batch request to queue

 @param request request
 */
- (void)addBatchRequest:(AppBatchRequest *)request;

/**
 Remove batch reqeust from queue

 @param request batch reqeust
 */
- (void)removeBatchRequest:(AppBatchRequest *)request;

@end

NS_ASSUME_NONNULL_END
