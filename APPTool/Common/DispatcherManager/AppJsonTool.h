//
//  AppJsonTool.h
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppJsonTool : NSObject

+ (NSString *)dictToJson:(NSDictionary *)dict;
+ (NSDictionary *)jsonToDict:(NSString *)json;

@end

NS_ASSUME_NONNULL_END
