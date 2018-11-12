//
//  NSString+Date.m
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "NSString+Date.h"


@implementation NSString (Date)

/**
 获取系统当前时间
 */
+ (NSString *)getTimeForCurrent {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //现在时间
    
    NSDate *datenow = [NSDate date];
    
    //将nsdate按formatter格式转成nsstring
    
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    //    debugLog(@"nowtimeStr =  %@",nowtimeStr);
    
    return nowtimeStr;
}

/**
 *    @brief    获取时间戳.
 *
 *    @param    index        index.
 *
 */
+ (NSString *)getTimeStamp:(NSInteger)index {
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate * localeDate = [datenow  dateByAddingTimeInterval: interval];
    return [NSString stringWithFormat:@"%lld", (long long)([localeDate timeIntervalSince1970] +index)];
}

/**
 *    @brief    转换时间为字符串.
 *
 *    @param    date        时间.
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString * destDateString = [dateFormatter stringFromDate:(NSDate *)date];
    return destDateString;
}

/**
 *    @brief    转换时间为字符串.
 *
 *    @param    date        时间.
 *    @param    formatter   时间格式.
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    [dateFormatter setDateFormat:formatter];
    NSString * stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}


/**
 时间标记

 @param timeString 标准时间
 @return 时间字符串
 */
+ (NSString *)transmitTime:(NSString *)timeString {
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date = [dateFormater dateFromString:timeString];
    
    NSDate * now = [NSDate date];
    
    NSTimeInterval cha = [now timeIntervalSinceDate:date];
    
    NSString * returnString = nil;
    if (cha < 60) {
        return @"刚刚";
    }else if (cha/3600 <= 1) {
        returnString = [NSString stringWithFormat:@"%f", cha/60];
        returnString = [returnString substringToIndex:returnString.length-7];
        returnString = [NSString stringWithFormat:@"%@分钟前", returnString];
        
    } else if (cha/(24 * 3600) <= 1) {
        returnString = [NSString stringWithFormat:@"%f", cha/3600];
        returnString = [returnString substringToIndex:returnString.length-7];
        returnString = [NSString stringWithFormat:@"%@小时前", returnString];
    }else if (cha/(7 * 24 * 3600) <= 1)
    {
        returnString = [NSString stringWithFormat:@"%f", cha/(24 * 3600)];
        returnString = [returnString substringToIndex:returnString.length-7];
        returnString = [NSString stringWithFormat:@"%@天前", returnString];
    }else if (cha/(7 * 24 * 3600) > 1)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSCalendarUnitDay |
                                        NSCalendarUnitMonth |
                                        NSCalendarUnitYear
                                        fromDate:date];
        
        NSInteger year  = [components year];
        NSInteger month = [components month];
        NSInteger day   = [components day];
        
        NSDateComponents *componentsCur = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitDay |
                                           NSCalendarUnitMonth |
                                           NSCalendarUnitYear
                                           fromDate:[NSDate date]];
        
        NSInteger curYear = [componentsCur year];
        
        if(year == curYear) {
            returnString = [NSString stringWithFormat:@"%ld-%ld",(long)month,(long)day];
        }
        else  {
            returnString = [NSString stringWithFormat:@"%lld-%ld-%ld",(long long)year,(long)month,(long)day];
        }
    }
    return returnString;
}

/**
 *@brief 计算离现在的时间.
 
 *@param theDate           时间.
 *@param dateFormat        时间格式.
 *@return
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate andDataFormat:(NSString *)dateFormat
{
    //首先创建格式化对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:dateFormat];
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:[NSDate date]];
    
    theDate = [NSString stringWithFormat:@"%@-%@",[NSString stringWithFormat:@"%zd",dateComponents.year],theDate];
    
    //然后创建日期对象
    
    NSDate *date1 = [dateFormatter dateFromString:theDate];
    
    NSDate *date = [NSDate date];
    
    //计算时间间隔（单位是秒）
    
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    
    int hours = ((int)time)%(3600*24)/3600;
    
    int minutes = ((int)time)%(3600*24)%3600/60;
    
    int seconds = (int)time %(3600 *24);
    
    NSString *timeString=@"";
    if ((seconds > 0 || seconds == 0) && minutes < 1) {
        timeString=[NSString stringWithFormat:@"%d秒后开始",seconds];
        if (seconds == 0) {
            timeString=@"0秒后开始";
            
        }
        
    }
    
    else if(minutes >0 && hours < 1) {
        timeString=[NSString stringWithFormat:@"%d分钟后开始",minutes];
    }
    else if (hours>0 && days<1) {
        timeString=[NSString stringWithFormat:@"%d小时后开始",minutes > 30 ? hours + 1 : hours];
        
    }else if (days > 0)
    {
        timeString=[NSString stringWithFormat:@"%d天后开始",hours > 12 ? days + 1 : days];
    }
    return timeString;
}

+ (NSString *)transmitThroughBrowseTime:(NSString *)timeString
{
    
    if ([timeString hasSuffix:@".0"]) {
        timeString = [timeString stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormater dateFromString:timeString];
    
    NSTimeInterval cha = [[NSDate date] timeIntervalSinceDate:date];
    
    if (date == nil) {
        return @"";
    }
    
    NSString * returnString = nil;
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                    fromDate:date];
    
    NSInteger year  = [components year];
    NSInteger month = [components month];
    NSInteger day   = [components day];
    NSInteger hour  = [components hour];
    
    NSDateComponents *componentsCur = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                       fromDate:[NSDate date]];
    
    NSInteger curMonth = [componentsCur month];
    NSInteger curYear = [componentsCur year];
    NSInteger curDay = [componentsCur day];
    
    if (curYear == year && curMonth == month && curDay == day) {
        returnString = @"今天";
    }
    else {
        
        if(year == curYear)
        {
            if (cha/(7 * 24 * 3600) <= 1) {
                
                returnString = [NSString stringWithFormat:@"%f", cha/(24 * 3600)];
                returnString = [returnString substringToIndex:returnString.length-7];
                if ([returnString isEqualToString:@"0"]) {
                    returnString = @"1";
                }
                NSInteger hours = cha / 3600;  //!< 总时长
                NSInteger hours1 = hours % 24; //!< 时间差
                if (hours1 > hour) {
                    returnString = [NSString stringWithFormat:@"%ld", (long)[returnString integerValue] + 1];
                }
                returnString = [NSString stringWithFormat:@"%@天前", returnString];
                
            } else {
                returnString = [NSString stringWithFormat:@"%ld月%ld日",(long)month,(long)day];
            }
        }
        else
        {
            returnString = [NSString stringWithFormat:@"%lld年%ld月%ld日",(long long)year,(long)month,(long)day];
        }
    }
    return returnString ? returnString : timeString;
}


@end
