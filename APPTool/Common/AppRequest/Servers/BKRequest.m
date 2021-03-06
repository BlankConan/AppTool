//
//  BKRequest.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKRequest.h"

@implementation BKRequest

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
    return @"此处填写baseurl";
}

- (NSString *)cdnUrl {
    return @"";
}


- (NSDictionary *)requestBaseArguments {
    return @{@"key":@"此处填写基参"};
}

- (BKRequestMethod)requestMethod {
    return BKRequestMethodGet;
}

// 默认为form表单格式
- (BKRequestSerializerType)requestSerializerType {
    return BKRequestSerializerHTTP;
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
    return [BKResult class];
}

- (void)cacheResult {}

#pragma mark - Private

- (void)convertJSON {
    id responseData = self.responseObject;
    if ([self jsonModeClass] && [[self jsonModeClass] isSubclassOfClass:[BKResult class]]) {
        id obj = [[self jsonModeClass] parseTotalData:responseData];
        self.result = obj;
        if ([self ignoreCache] == NO) {
            [self cacheResult];
        }
    }
}


@end
