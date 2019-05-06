//
//  BKRequest.h
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKBaseRequest.h"
#import "BKResult.h"

/**
 App 请求类
 每个接口继承 BKRequest
 每个接口重载 requesturl
 每个接口重载 arguments
 @optional
 每个接口重载 baseReqeustUrl
 
 */
@interface BKRequest : BKBaseRequest

/// data.
@property (nonatomic, strong) BKResult *result;

/// yes - ignore cache.
@property (nonatomic, assign) BOOL ignoreCache;

// 子类需要重载，返回的class都是result的子类
- (Class)jsonModeClass;

/**
 对结果进行缓存
 */
- (void)cacheResult;

@end


