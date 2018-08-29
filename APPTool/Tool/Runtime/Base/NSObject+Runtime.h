//
//  NSObject+Runtime.h
//  APPTool
//
//  Created by liu gangyi on 2018/7/27.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtime)


/**
 获取所有的实例方法

 @return 实例方法数组
 */
+ (nullable NSArray *)allInstanceMethod;

/**
 获取所有的类方法

 @return 类方法数组
 */
+ (nullable NSArray *)allStaticMethod;


/**
 所有属性

 @return 所有的属性数组
 */
+ (nullable NSArray *)allProperties;


/**
 所有的实例变量

 @return 返回一个数组，包含所有的实例变量，如果为空返回nil
 */
+ (nullable NSArray *)allInstanceVariables;


@end
