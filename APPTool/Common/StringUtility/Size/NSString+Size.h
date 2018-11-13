//
//  NSString+Size.h
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//


@interface NSString (Size)

/**
 *    @brief    计算长度.
 *
 *    @param    font        font.
 *    @return   返回 CGSize value.
 *
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font;

/**
 *    @brief    计算长度.
 *
 *    @param    font            font.
 *    @param    size            size.
 *    @param    lineBreakMode   lineBreakMode.
 *    @return   返回 CGSize value.
 *
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *    @brief    计算长度.
 *
 *    @param    font            font.
 *    @param    width           width.
 *    @param    lineBreakMode   lineBreakMode.
 *    @return   返回 CGSize value.
 *
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *    @brief    绘制文本.
 *
 *    @param    rect        rect.
 *    @param    font        font.
 *
 */
- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font;

/**
 *  Get the string's height with the fixed width.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *  @param width     Fixed width.
 *
 *  @return String's height.
 */
- (CGFloat)heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute fixedWidth:(CGFloat)width;

/**
 *  Get the string's width.
 *
 *  @param attribute String's attribute, eg. attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]}
 *
 *  @return String's width.
 */
- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;

/**
 比较两个版本大小
 
 @param versionA 版本1
 @param versionB 版本2
 @return 返回YES说明前者大于后者
 */
+ (BOOL)compareVersionA:(NSString *)versionA versionB:(NSString *)versionB;

@end
