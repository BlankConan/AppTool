//
//  AppRequest.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "AppRequest.h"

@implementation AppRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ignoreCache = YES;
        self.requestTimeoutInterval = 15;
        
    }
    return self;
}

#pragma mark overrid

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)cdnUrl {
    return @"";
}


- (NSDictionary *)requestBaseArguments {
    return @{};
}

- (void)start {
    [super start];
}

// 请求成功进行数据解析
- (void)requestSuccessFilter {
    [self convertJSON];
}

// 请求失败
- (void)requestFailureFilter {}

// 将数据交给result，必须都是AppResult的子类
- (Class)jsonModeClass {
    return [AppResult class];
}

- (void)cacheResult {}

#pragma mark - Private

- (void)convertJSON {
    NSDictionary *resultDic = self.responseObject;
    if ([self jsonModeClass] && [[self jsonModeClass] isSubclassOfClass:[AppResult class]]) {
        id obj = [[self jsonModeClass] parseTotalData:resultDic];
        self.result = obj;
        if ([self ignoreCache] == NO) {
            [self cacheResult];
        }
    }
}


@end
