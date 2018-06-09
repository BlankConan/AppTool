//
//  DatabaseTool.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/6.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "DatabaseTool.h"
#import "FMDB.h"

/// 主键
static NSString *kPrimaryKey = @"appId";
/// 数据库名称.
static NSString *kAppDateBaseName = @"appDB.db";

static FMDatabaseQueue *_dbQueue;

typedef enum : NSUInteger {
    CreateSql = 1,
    UpdateSql,
    InsertSql,
    DeleteSql,
} FormateSqlType;


@implementation DatabaseTool

#pragma mark - Private Create DB
+ (NSString *)dbPath {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[kDocPath stringByAppendingPathComponent:kDB_PARH]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[kDocPath stringByAppendingPathComponent:kDB_PARH] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return  [[kDocPath stringByAppendingPathComponent:kDB_PARH] stringByAppendingPathComponent:kAppDateBaseName];
}


#pragma mark - Public

+ (void)init {
    [self initDB];
}

+ (void)initDB {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:[self dbPath]];
        [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            [db setShouldCacheStatements:YES];
        }];
    });
}

+ (void)closeDB {
    [_dbQueue close];
}

+ (void)createTableWithSql:(NSString *)tableSql tableName:(NSString *)tableName {
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db tableExists:tableName]) {
            NSString *sql = [self initSqlCreateTableWithColumnSql:tableSql tableName:tableName];
            [self excuteUpdateSql:sql db:db];
        }
    }];
}

/**
 向表中插入数据

 @param keyValues 数据
 @param tableName 表
 */
+ (void)insertWithKeyValues:(NSDictionary *)keyValues replace:(BOOL)replace tableName:(NSString *)tableName {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
       
        if (![db tableExists:tableName]) {
            NSString *insertSql = nil;
            NSMutableArray *values = [NSMutableArray array];
            
            if (keyValues) {
                NSMutableArray *columns = [NSMutableArray array];
                NSMutableArray *placeHolder = [NSMutableArray array];
                
                [keyValues enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if (obj && ![obj isEqual:[NSNull null]]) {
                        NSString *sKey = [NSString stringWithFormat:@"%@", key];
                        [columns addObject:sKey];
                        [values addObject:obj];
                        [placeHolder addObject:@"?"];
                    }
                }];
                
                insertSql = [[NSString alloc] initWithFormat:@"INSERT %@ INTO %@ (%@) VALUES (%@)", replace? @"OR REPLACE":@"", tableName, [columns componentsJoinedByString:@","], [placeHolder componentsJoinedByString:@","]];
            }
            
            [self excuteUpdateSql:insertSql values:values db:db];
        }
    }];
}

//+ (void)insertBatchWithKV:(NSArray *)keyValues replace:(BOOL)replace trableName:

/**
 删除一张表

 @param tableName 表名
 */
+ (void)deleteTableOfDB:(NSString *)tableName {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        if (![db tableExists:tableName]) {
            NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
            [self excuteUpdateSql:sql db:db];
        }
    }];
}

/**
 删除表中的某一条数据或者全部数据

 @param conditions nil->全部数据；否则根据条件删除
 @param tableName 表名
 */
+ (void)deleteDataeOfTableWithCondition:(NSDictionary * _Nullable)conditions tableName:(NSString *)tableName {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [self initSqlDeleteWithCondition:conditions tableName:tableName];
        [self excuteUpdateSql:sql db:db];
    }];
}

/**
 查询表中的数据

 @param conditions 如果为nil，则返回表中所有数据；否则根据条件查询
 @param tableName 表名
 @return 返回结果
 */
+ (NSArray *)queryDataWithCondition:(NSDictionary * _Nullable)conditions tableName:(NSString *)tableName {
    
    // 定义一个存储转换后的结果
    NSMutableArray *resultArr = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [self initSqlQureyWithCondition:conditions tableName:tableName];
        // 查找结果为 resultSet
        FMResultSet *result = [db executeQuery:sql];
        while ([result next]) {
            // 将一个row映射出一个字典，添加到结果中
            [resultArr addObject:result.resultDictionary];
        }
        
        // 关闭结果集
        [result close];
    }];
    
    return [NSArray arrayWithArray:resultArr];
}


#pragma mark - 辅助方法--操作数据库(这些方法可以外接fmdb)

+ (BOOL)excuteUpdateSql:(NSString * _Nullable)sql db:(FMDatabase *)db{
    
    if (!sql) {
        NSLog(@"sql语句错误");
        return NO;
    }
    
    return [db executeUpdate:sql];
}

+ (BOOL)excuteUpdateSql:(NSString * _Nullable)sql values:(NSArray * _Nullable)values db:(FMDatabase *)db {
    
    if (!sql) {
        NSLog(@"sql语句错误");
        return NO;
    }
    
    return [db executeUpdate:sql withArgumentsInArray:values];
}

/**
 表是否存在

 @param tableName 表名
 @param db 操作的数据库
 @return Yes-存在
 */
+ (BOOL)tableExist:(NSString *)tableName db:(FMDatabase *)db {
    return [db tableExists:tableName];
}

/**
 表中的某列是否存在

 @param column 列
 @param tableName 表名
 @param db 数据库
 @return 返回值
 */
+ (BOOL)columnExist:(NSString *)column table:(NSString *)tableName db:(FMDatabase *)db {
    return [db columnExists:column inTableWithName:tableName];
}


#pragma mark - 辅助方法--生成对应的SQL语句

/**
 创建表

 @param columnSql 要创建的列
 @param tableName 表名
 @return 返回创建表的SQL语句
 */
+ (NSString *)initSqlCreateTableWithColumnSql:(NSString *)columnSql tableName:(NSString *)tableName {
    NSString *createTabSql = [NSString stringWithFormat:@"CREATE TABLE %@ (%@ integer primary key autoincrement not null), %@", tableName, kPrimaryKey, columnSql];
    return createTabSql;
}

/**
 更新指定的数据

 @param columnDic 以字典的形式给定数据
 @param conditionDic 条件语句
 @param tableName 要操作的表名
 @return 返回更新表中数据的SQL语句
 */
+ (NSString * _Nullable)initUpdateSqlWithColumnDataDic:(NSDictionary *)columnDic conditionsDic:(NSDictionary * _Nullable)conditionDic tableName:(NSString *)tableName {
    
    NSString *updateSql = nil;
    
    // update table_name set column1 = value1, column2 = value2
    if (columnDic) {
        NSMutableArray *keyValues = [NSMutableArray array];
        
        [columnDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (obj && ![obj isEqual:[NSNull null]]) {
                NSString *sKey = [NSString stringWithFormat:@"%@", key];
                NSString *sValue = [NSString stringWithFormat:@"%@", obj];
                NSString *keyValue = [NSString stringWithFormat:@"%@ = %@", sKey, sValue];
                [keyValues addObject:keyValue];
            }
        }];
        updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@", tableName, [keyValues componentsJoinedByString:@","]];
        
        // 如果存在限定条件
        if (conditionDic) {
            [keyValues removeAllObjects];
            [conditionDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if (obj && ![obj isEqual:[NSNull null]]) {
                    NSString *sKey = [NSString stringWithFormat:@"%@", key];
                    NSString *sValue = [NSString stringWithFormat:@"%@", obj];
                    NSString *keyValue = [NSString stringWithFormat:@"%@ = %@", sKey, sValue];
                    [keyValues addObject:keyValue];
                }
            }];
            updateSql = [updateSql stringByAppendingFormat:@" WHERE %@", [keyValues componentsJoinedByString:@","]];
        }
    }
    
    return updateSql;
}

/**
 删除表中指定的数据或者全部数据

 @param condition 如果为空则为全部数据
 @param tableName 操作的表名
 @return 返回删除SQL语句
 */
+ (NSString * )initSqlDeleteWithCondition:(NSDictionary * _Nullable)condition tableName:(NSString *)tableName {
    NSString *deleteSql = nil;
    if (condition) {
        NSMutableArray *keyValues = [NSMutableArray array];
        
        [condition enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (obj && ![obj isEqual:[NSNull null]]) {
                NSString *sKey = [NSString stringWithFormat:@"%@", key];
                NSString *sValue = [NSString stringWithFormat:@"%@", obj];
                NSString *keyValue = [NSString stringWithFormat:@"%@ = %@", sKey, sValue];
                [keyValues addObject:keyValue];
            }
        }];
        deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, [keyValues componentsJoinedByString:@","]];
    } else {
        deleteSql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    }
    return deleteSql;
}

/**
 格式化查询语句

 @param condition 如果为nil，则返回表中所有数据；否则根据条件查询
 @param tableName 表名
 @return SQL语句
 */
+ (NSString * )initSqlQureyWithCondition:(NSDictionary * _Nullable)condition tableName:(NSString *)tableName {
    NSString *deleteSql = nil;
    if (condition) {
        NSMutableArray *keyValues = [NSMutableArray array];
        
        [condition enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (obj && ![obj isEqual:[NSNull null]]) {
                NSString *sKey = [NSString stringWithFormat:@"%@", key];
                NSString *sValue = [NSString stringWithFormat:@"%@", obj];
                NSString *keyValue = [NSString stringWithFormat:@"%@ = %@", sKey, sValue];
                [keyValues addObject:keyValue];
            }
        }];
        deleteSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", tableName, [keyValues componentsJoinedByString:@","]];
    } else {
        deleteSql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    }
    return deleteSql;
}

/**
 重命名表

 @param tableName 原表名
 @param newTabName 新表名
 @return SQL语句
 */
+ (NSString *)initSqlRenameTableWithTableName:(NSString *)tableName newTabName:(NSString *)newTabName {
    return [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@", tableName, newTabName];
}

//ALTER TABLE OLD_COMPANY ADD COLUMN SEX char(1);
+ (NSString *)initSqlWithTableName:(NSString *)tableName newTabName:(NSString *)newTabName {
    return [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@", tableName, newTabName];
}


@end

