//
//  BKBatchRequest.h
//  APPTool
//
//  Created by liugangyi on 2018/11/14.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BKBatchRequest;
@class BKRequest;

// batch rquest protocol
@protocol BKBatchRequestDelegate <NSObject>

@optional

/**
 success

 @param batchRequest request
 */
- (void)batchRequestSuccessed:(BKBatchRequest *)batchRequest;

/**
 failured

 @param batchRequest request
 */
- (void)batchRequestFailured:(BKBatchRequest *)batchRequest failuredReqeust:(BKRequest *)reqeust;

@end

@interface BKBatchRequest : NSObject

/// store sub request.
@property (nonatomic, strong, readonly) NSMutableArray<BKRequest *> *requestArray;
/// delegate.
@property (nonatomic, weak, nullable) id<BKBatchRequestDelegate> delegate;
/// success block.
@property (nonatomic, copy, nullable) void (^successCompleteBlock)(BKBatchRequest *);
/// failured block.
@property (nonatomic, copy, nullable) void (^failuredCompleteBlock)(BKBatchRequest *, BKRequest *);
/// The first request that failed.
@property (nonatomic, strong, readonly, nullable) BKRequest *failedRequest;
/// task num.
@property (nonatomic, assign) NSUInteger tag;
/**
 initilize

 @param requestArray container of subclass of AppBaseRequest
 @return batch reqeust
 */
- (instancetype)initWithRequestArray:(NSArray <BKRequest *> *)requestArray;

/**
 Set callback block

 @param success success block
 @param failured failured request will be returned, and current batchrequest
 */
- (void)setCompleteBlockWithSuccess:(void (^)(BKBatchRequest *batchRequest))success
                           failured:(void (^)(BKBatchRequest *batchRequest, BKRequest *request))failured;


/**
 Start request and call back

 @param success success block
 @param failured failured request will be returned, and current batchrequest
 */
- (void)startCompleteBlockWithSuccess:(void (^)(BKBatchRequest *batchRequest))success
                             failured:(void (^)(BKBatchRequest *batchRequest, BKRequest *request))failured;

/**
 Add request into batch queue,
 batch request is started through `startCompleteBlockWithSuccess:failured:`

 @param request AppRequest instance
 @param success AppRequest instance
 @param failured AppRequest instace
 */
- (void)addRequest:(BKRequest *)request
completeWithSuccess:(void (^)(BKRequest *))success
          failured:(void (^)(BKRequest *))failured;

/**
 Add request to request queue and start task automatic
 */
- (void)start;

/**
 Remove from request queue and stop task automatic
 */
- (void)stop;


/**
 Nil out both success and failure callback blocks
 */
- (void)clearCompletionBlock;

@end

NS_ASSUME_NONNULL_END
