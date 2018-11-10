//
//  DatabaseTool.h
//  APPTool
//
//  Created by liu gangyi on 2018/6/6.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseTool : NSObject

/**
 初始化数据库
 */
+ (void)initDB;

+ (void)closeDB;

+ (void)createTableWithSql:(NSString *)tableSql tableName:(NSString *)tableName;

+ (void)insertWithKeyValues:(NSDictionary *)keyValues replace:(BOOL)replace tableName:(NSString *)tableName;

+ (NSArray *)queryDataWithCondition:(NSDictionary * _Nullable)conditions tableName:(NSString *)tableName;

+ (void)deleteTableOfDB:(NSString *)tableName;

+ (void)deleteDataeOfTableWithCondition:(NSDictionary * _Nullable)conditions tableName:(NSString *)tableName;


@end
