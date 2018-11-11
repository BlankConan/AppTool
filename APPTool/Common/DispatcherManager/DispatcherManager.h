//
//  DispatcherManager.m
//  AppTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Dispatcher;
@interface DispatcherManager : NSObject

/**
 *  根据transformType，处理后台远程调用内部组件功能
 *
 *  @param json   后台传入的json指令
 *  @param parent parent controller
 *  @param completion 完成后执行的block
 *
 *  @return 返回相应的值
 */
+ (id)dispatcherFromRemote:(NSString *)json parent:(UIViewController *)parent completion:(void (^)(NSDictionary *))completion;

/**
 *  处理后台远程调用内部组件功能，采用push transform
 *
 *  @param json   后台传入的json指令
 *  @param parent parent controller
 *  @param completion 完成后执行的block
 */
+ (void)dispatcherWithPush:(NSString *)json parent:(UIViewController *)parent completion:(void (^)(NSDictionary *))completion;

/**
 *  处理后台远程调用内部组件功能，采用present transform
 *
 *  @param json   后台传入的json指令
 *  @param parent parent controller
 *  @param completion 完成后执行的block
 */
+ (void)dispatcherWithPresent:(NSString *)json parent:(UIViewController *)parent completion:(void (^)(NSDictionary *))completion;

/**
 *  处理后台远程调用内部组件功能，不需要进行UI transform，只是执行某个组件功能，且返回相应的值
 *
 *  @param json       后台传入的json指令
 *  @param completion 完成后执行的block
 *
 *  @return 返回相应的值，最好为dic类型
 */
+ (id)dispatcherWithNo:(NSString *)json completion:(void (^)(NSDictionary *))completion;

@end
