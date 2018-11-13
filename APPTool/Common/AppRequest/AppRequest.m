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


//- (Class)jsonModeClass:(NSDictionary *)dictResult {
//
//}

#pragma mark overrid

- (void)start {
    [super start];
}




@end
