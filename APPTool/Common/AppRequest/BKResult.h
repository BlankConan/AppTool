//
//  BKResult.h
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKResult : NSObject


/// responseMessage.
@property (nonatomic, copy) NSString *responseMessage;
/// responseCode.
@property (nonatomic, copy) NSString *responseCode;
/// responseStatus.
@property (nonatomic, strong) NSNumber *responseStatus;
/// responsePk.
@property (nonatomic, strong) NSNumber *responsePk;


/**
 通过yymodel自动解析所有json数据

 @param jsonDic 由json转过来的dic
 @return 返回解析的数据Model
 */
+ (instancetype)parseTotalData:(NSDictionary *)jsonDic;

@end
