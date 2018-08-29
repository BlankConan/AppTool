//
//  NSObject+Runtime.m
//  APPTool
//
//  Created by liu gangyi on 2018/7/27.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)

#pragma mark - Public Method



+ (nullable NSArray *)allStaticMethod {
    
    // 获取元类共两种方法
    // 第一种
    Class metaClass = objc_getMetaClass(class_getName([self class]));
    // 第二种
//    Class class_object = [self class];
//    Class class_meta = object_getClass(class_object);
    
    return [self methodList:metaClass];
}

+ (nullable NSArray *)allInstanceMethod {
    return [self methodList:[self class]];
}

+ (nullable NSArray *)allProperties {
    
    unsigned int count = 0;
    objc_property_t *propertiesList = class_copyPropertyList([self class], &count);
    
    if (count == 0) {
        free(propertiesList);
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertiesList[i];
        // 属性名称
        const char *property_name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:property_name];
        
        debugLog(@"%@", propertyName);
        [arr addObject:propertyName];
    }
    free(propertiesList);
    return arr;
}

+ (NSArray *)allInstanceVariables {
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    
    if (count == 0) {
        free(ivarList);
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        Ivar currentIvar = ivarList[i];
        // 实例变量名
        const char *ivar_name = ivar_getName(currentIvar);
        NSString *ivarName = [NSString stringWithUTF8String:ivar_name];
       
        // 获取值
        id value = [self valueForKey:[ivarName substringFromIndex:1]];
        if (value) {
             debugLog(@"%@=%@", ivarName, value);
        } else {
             debugLog(@"%@", ivarName);
        }
        
        [arr addObject:ivarName];
    }
    
    return arr;
}

#pragma mark - 辅助方法

+ (NSArray *)methodList:(Class)cls {
    
    unsigned int count = 0;
    Method *methodlist = class_copyMethodList(cls, &count);
    
    if (count == 0) {
        free(methodlist);
        return nil;
    }
    
    NSMutableArray *narray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        Method currentMethod = methodlist[i];
        
        // 方法具体实现
//        IMP imp = method_getImplementation(currentMethod);
        // 方法签名
        SEL sel_name = method_getName(currentMethod);
        // 方法名字
        const char* method_name = sel_getName(sel_name);
        // 前两个参数被系统占用
        int arguments = method_getNumberOfArguments(currentMethod) - 2;
        
        // 编码方式
        const char* encoding = method_getTypeEncoding(currentMethod);
        
        // 返回类型
        char * returnType = nil;
        method_getReturnType(currentMethod, returnType, sizeof(returnType));
        
        [narray addObject:[NSString stringWithUTF8String:method_name]];
        
        debugLog(@"方法名:%s  参数个数:%d   编码方式: %s  返回类型:%s", method_name, arguments, encoding, returnType);
    }
    free(methodlist);
    
    return [narray copy];
}


@end
