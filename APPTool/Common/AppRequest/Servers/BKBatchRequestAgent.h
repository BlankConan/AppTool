//
//  AppBatchRequestAgent.h
//  APPTool
//
//  Created by liugangyi on 2018/11/14.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BKBatchRequest;

@interface BKBatchRequestAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)shareInstance;

/**
 Add batch request to queue

 @param request request
 */
- (void)addBatchRequest:(BKBatchRequest *)request;

/**
 Remove batch reqeust from queue

 @param request batch reqeust
 */
- (void)removeBatchRequest:(BKBatchRequest *)request;

@end

NS_ASSUME_NONNULL_END
