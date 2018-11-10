//
//  AppAPIDebug.h
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#ifndef AppAPIDebug_h
#define AppAPIDebug_h

#define visitSiteID @"5"
#define resetSite @"5"

#pragma

#define kMD5PrivateKey @"e2s0m1"
#pragma
#pragma mark 线上线下的开关

/// 线上线下开关   1线上  0线下.
#define ON_LINE 0
//#define kOnlineSetting         [AllinUserDefault boolForKey:@"allinmdServePreferance"]
///// 是否使用HTTPS.
//#define https
//#define kSetting
//
/**
 * https 为是否使用https的设置，如果要使用https 那么打开 #define https 否则关掉，
 * kSetting 为 是否使用bundle设置线上线下环境设置，如果打开，那么可以在手机设置-唯医里面找到线上线下的设置
 */

#ifdef https

#ifdef kSetting

#else

#endif

#else

#ifdef kSetting

#else


#endif

#endif


#define AllIN_ServerUploadOrignalImg(a) (a)? @"https://image.allinmd.cn:8096/" : \
@"http://192.168.1.133:8096/"

#define AllIN_ServerWechatLogin @"customer/unite/v2/weixinLogin";
#define AllIN_ServerWechatBind @"customer/unite/info/v2/createWxUnionIdBind";
#pragma
#pragma mark 数据库

/// 数据库版本号.
#define kSQLVID @"10000"

#endif /* AppAPIDebug_h */
