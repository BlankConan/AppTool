//
//  DispatcherManager.m
//  AppTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "DispatcherManager.h"
#import "AppJsonTool.h"
#import "Dispatcher.h"

typedef NS_ENUM (NSUInteger, DispatchTransformType) {
    DispatchTransformTypePush = 0,//ViewController push进来
    DispatchTransformTypePresent = 1,//ViewController present进来
    DispatchTransformTypeNo = 2,//只是执行Native某个操作，而没有UI动作
    DispatchTransformTypeDefault = DispatchTransformTypePush
};

@implementation DispatcherManager

+ (id)dispatcherFromRemote:(NSString *)json parent:(UIViewController *)parent completion:(void (^)(NSDictionary *))completion {
    
    id result = nil;
    if (json) {
        NSDictionary *dic = [AppJsonTool jsonToDict:json];
        if (dic) {
            NSInteger transformType = ((NSString *)dic[kDispatcherTransformType]).integerValue;
            switch (transformType) {
                case DispatchTransformTypePush:
                    [self dispatcherWithPush:json parent:parent completion:completion];
                    break;
                case DispatchTransformTypePresent:
                    [self dispatcherWithPresent:json parent:parent completion:completion];
                    break;
                case DispatchTransformTypeNo:
                    result = [self dispatcherWithNo:json completion:completion];
                    break;
                    
                default:
                    [self dispatcherWithPush:json parent:parent completion:completion];
                    break;
            }
        }
    }
    return result;
}

+ (void)dispatcherWithPush:(NSString *)json parent:(UIViewController *)parent completion:(void (^)(NSDictionary *))completion {
    
    if (parent && json) {
        UIViewController *targetVC = [[Dispatcher sharedInstance] performActionWithJson:json completion:completion];
        if (targetVC && [targetVC isKindOfClass:[UIViewController class]] &&
            [parent isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)parent pushViewController:targetVC animated:YES];
        }
    }
}

+ (void)dispatcherWithPresent:(NSString *)json parent:(UIViewController *)parent completion:(void (^)(NSDictionary *))completion{
    
    if (parent && json) {
        UIViewController *targetVC = [[Dispatcher sharedInstance] performActionWithJson:json completion:completion];
        if (targetVC && [targetVC isKindOfClass:[UIViewController class]]) {
            [parent presentViewController:targetVC animated:YES completion:nil];
        }
    }
}

+ (id)dispatcherWithNo:(NSString *)json completion:(void (^)(NSDictionary *))completion {
    
    id result = nil;
    if (json) {
        result = [[Dispatcher sharedInstance] performActionWithJson:json completion:completion];
    }
    return result;
}

@end
