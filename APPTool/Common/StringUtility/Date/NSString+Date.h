//
//  NSString+Date.h
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (Date)

/**
 获取系统当前时间
 */
+ (NSString *)getTimeForCurrent;

/**
 @brief    获取时间戳.
 
 @param    index   index.
 @return   返回 时间戳 value.

 */
+ (NSString *)getTimeStamp:(NSInteger)index;

/**
 @brief    转换时间为字符串.

 @param    date        时间.
 @return   返回  value.
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 转换时间为字符串.
 
 @param    date        时间.
 @param    formatter   时间格式.
 @return   返回  value.
 */
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;

/**
 转换时间

 @param    timeString ""
 @return   返回 时间 value
 */
+ (NSString *)transmitTime:(NSString *)timeString;

/**
 计算离现在的时间

 @param theDate 时间
 @param dateFormat 时间格式
 @return ""
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate andDataFormat:(NSString *)dateFormat;

+ (NSString *)transmitThroughBrowseTime:(NSString *)timeString;


@end

