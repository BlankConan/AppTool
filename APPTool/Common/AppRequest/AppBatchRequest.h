//
//  AppBatchRequest.h
//  APPTool
//
//  Created by liugangyi on 2018/11/14.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppBatchRequest;
@class AppBaseRequest;

// batch rquest protocol
@protocol APPBatchRequestDelegate <NSObject>

@optional

/**
 success

 @param batchRequest request
 */
- (void)batchRequestSuccessed:(AppBatchRequest *)batchRequest;

/**
 failured

 @param batchRequest request
 */
- (void)batchRequestFailured:(AppBatchRequest *)batchRequest;

@end

@interface AppBatchRequest : NSObject

/// store sub request.
@property (nonatomic, strong, readonly) NSMutableArray *requestArray;
/// delegate.
@property (nonatomic, weak) id<APPBatchRequestDelegate> delegate;
/// success block.
@property (nonatomic, copy) void (^successCompleteBlock)(AppBatchRequest *);
/// failured block.
@property (nonatomic, copy) void (^failuredCompleteBlock)(AppBatchRequest *);
/// task num.
@property (nonatomic, assign) NSUInteger tag;

/**
 initilize

 @param requestArray container of subclass of AppBaseRequest
 @return batch reqeust
 */
- (instancetype)initWithRequestArray:(NSArray <AppBaseRequest *> *)requestArray;

/**
 Set callback block

 @param success success block
 @param failured failured request will be returned, and current batchrequest
 */
- (void)setCompleteBlockWithSuccess:(void (^)(AppBatchRequest *))success failured:(void (^)(AppBatchRequest *, AppBaseRequest *))failured;


/**
 Start request and call back

 @param success success block
 @param failured failured request will be returned, and current batchrequest
 */
- (void)startCompleteBlockWithSuccess:(void (^)(AppBatchRequest *))success failured:(void (^)(AppBatchRequest *, AppBaseRequest *))failured;


/**
 Add request to request queue and start task automatic
 */
- (void)start;

/**
 Remove from request queue and stop task automatic
 */
- (void)stop;


@end


