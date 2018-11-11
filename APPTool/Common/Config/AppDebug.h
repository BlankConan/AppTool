//
//  DebugMacro.h
//  APPTool
//
//  Created by liu gangyi on 2018/6/8.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#ifndef DebugMacro_h
#define DebugMacro_h


/// 打印日志.
#ifdef DEBUG

#define debugLog( s, ... ) NSLog( @"%@ \r\n Class: %@   Line: %d ", \
                           [NSString stringWithFormat:(s), ##__VA_ARGS__],  \
                           [[NSString stringWithUTF8String:__FILE__] lastPathComponent],\
                           __LINE__ )

#define debugMethod() NSLog(@"%s", __func__)

#else

#define debugLog(s, ...)
#define debugMethod()

#endif

// 引用计数
#define RetainCount(obj) CFGetRetainCount((__bridge CFTypeRef)(obj))
#define logRetainCount(obj) NSLog(@"%ld", CFGetRetainCount((__bridge CFTypeRef)(obj)));

/// 归档/解档.
#define OBJC_STRING(x) @#x
#define Decode(x) self.x = [aDecoder decodeObjectForKey:OBJC_STRING(x)]
#define Encode(x) [aCoder encodeObject:self.x forKey:OBJC_STRING(x)]

/// 主线程.
#define dispatch_main_queue_async(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

/// ALAppDelegate相关.
#define kAppDelegate   (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define kAppWindow        [[[UIApplication sharedApplication] delegate] window]
#define kAppRootVC      (RootVC *)[[[UIApplication sharedApplication] delegate] window].rootViewController

/// weakSelf.
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;

//============================== 屏幕的尺寸 ==============================
#define PHONE_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define PHONE_HEIGH  (([UIApplication sharedApplication].statusBarFrame.size.height > 20 && !IS_IPHONE_X ) ? \
(([[UIScreen mainScreen] bounds].size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20)) : \
[[UIScreen mainScreen] bounds].size.height)

//============================== 适配 ==============================
/// 设计稿是5s 适配各种屏幕比例.
#define kScreenScaleWidth               [UIScreen mainScreen].bounds.size.width/320.0
#define kScreenScaleHeight              ([UIScreen mainScreen].bounds.size.height/568.0 == 1 ? \
1 : [UIScreen mainScreen].bounds.size.height/568.0)

#define kFitWidth_5(a)                  ((a) * (kScreenScaleWidth))
#define kFitHeight_5(a)                 ((a) * (kScreenScaleHeight))

/// 设计稿是6  适配各种屏幕比例.
#define kScreenNewScaleWidth            [UIScreen mainScreen].bounds.size.width/375.0
#define kScreenNewScaleHeight           (([UIScreen mainScreen].bounds.size.height/667.0==1) || IS_IPHONE_X  ? \
1 : [UIScreen mainScreen].bounds.size.height/667.0)



#define kFitWidth_6(a)                  ((a) * (kScreenNewScaleWidth))
#define kFitHeight_6(a)                 ((a) * (kScreenNewScaleHeight))
//是否为iOS9以上版本
#define kIOS9x ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)


#endif /* DebugMacro_h */
