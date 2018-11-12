//
//  AppRequest.h
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppBaseRequest.h"
#import "AppResult.h"

/**
 App 请求类
 每个接口继承AppRequest
 每个接口重载 requesturl
 */
@interface AppRequest : AppBaseRequest

// data
@property (nonatomic, strong) AppResult *result;

// yes - ignore cache
@property (nonatomic, assign) BOOL ignoreCache;

- (Class)jsonModeClass:(NSDictionary *)dictResult;

@end


