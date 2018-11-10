//
//  NSString+MD5.h
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

@interface NSString (MD5)

/**
 *    @brief    MD5加密.
 *
 *    @return   返回 value.
 *
 */
- (NSString *)MD5Hash;

/**
 *    @brief    MD5加密 32位 .
 *
 *    @return   返回 value.
 *
 */
+ (NSString *)md5EncryptWithString:(NSString *)string;

@end
