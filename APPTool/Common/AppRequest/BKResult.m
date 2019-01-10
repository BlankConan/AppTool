//
//  AppResult.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKResult.h"

@implementation BKResult

+ (instancetype)parseTotalData:(NSDictionary *)jsonDic {
    
    // 自动解析所有的数据，不过只让他解析 response 有关的
    BKResult *parentResult = [BKResult parseJsonData:jsonDic];
    // 自动解析 真实数据
    BKResult *dataResult = [[self class] parseJsonData:jsonDic[@"responseData"]];
    dataResult.responsePk = parentResult.responsePk;
    dataResult.responseCode = parentResult.responseCode;
    dataResult.responseMessage = parentResult.responseMessage;
    dataResult.responseStatus = parentResult.responseStatus;
    
    return dataResult;
}


#pragma mark - Private

// 解析 字典里面的数据
+ (instancetype)parseJsonData:(id)responceData {
    id result = [[self class] yy_modelWithDictionary:responceData];
    return result;
}

#pragma mark - YYModel 协议实现

// 白名单 只有白名单里面的内容会通过
+ (NSArray *)modelPropertyWhitelist {
    return @[@"responseMessage", @"responseStatus", @"responseCode", @"responseMessage"];
}

//// 黑名单
//+ (NSArray *)modelPropertyBlacklist {
//    return @[@"test1", @"test2"];
//}

//// 自定义 keypath 进行映射
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"name" : @"n",
//             @"page" : @"p",
//             @"desc" : @"ext.desc",
//             @"bookID" : @[@"id",@"ID",@"book_id"]};
//}

//// 模型里面容器映射的方法
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    // value should be Class or Class name.
//    return @{@"shadows" : [Shadow class],
//             @"borders" : Border.class,
//             @"attachments" : @"Attachment" };
//}

//// dic -> model 转完之后会调用，在里面可以对数据重新整理
//- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
//    NSNumber *timestamp = dic[@"timestamp"];
//    if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
//    _createdAt = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
//    return YES;
//}

//// model -> dic 转完之后会调用
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    if (!_createdAt) return NO;
//    dic[@"timestamp"] = @(n.timeIntervalSince1970);
//    return YES;
//}


@end
