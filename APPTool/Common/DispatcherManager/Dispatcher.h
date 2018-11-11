//
//  Dispatcher.h
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kDispatcherScheme;
extern NSString * const kDispatcherTarget;
extern NSString * const kDispatcherAction;
extern NSString * const kDispatcherTransformType;
extern NSString * const kDispatcherParams;

@interface Dispatcher : NSObject

@property (copy, nonatomic) NSString * appName;

+ (instancetype)sharedInstance;

/**
 *  远程App调用入口，从其他app调用本app时调用
 *
 *  @param url        scheme://[target]/[action]?[params]
 *                    url sample:
 *                    DongAoAcc://targetA/actionB?id=1234
 *  @param completion 完成时执行的block
 *
 *  @return 返回执行结果
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

/**
 *  远程后台调用入口，后台传入json
 *
 *  @param json 转换成dic后格式如下：
 *               scheme：后台定的应用名称
 *               target：组件模块名称
 *               action：组件功能
 *               params：对应参数，应该是个dic
 *  @param completion 完成时执行的block
 *
 *  @return 返回执行结果
 */
- (id)performActionWithJson:(NSString *)json completion:(void(^)(NSDictionary *info))completion;

/**
 *  本地组件调用入口
 *
 *  @return 返回执行结果
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
