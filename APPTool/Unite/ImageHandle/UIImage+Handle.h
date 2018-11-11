//
//  UIImage+Handle.h
//  APPTool
//
//  Created by liugangyi on 2018/11/8.
//  Copyright © 2018 liu gangyi. All rights reserved.
//



@interface UIImage (Handle)

/**
 生成指定尺寸的图片（对大分辨率图片处理不友好）

 @param image 原始图片
 @param newSize 目标尺寸
 @return 生成目标尺寸对应的图片
 */
- (UIImage *)scaleImage:(UIImage *)image newSize:(CGSize)newSize;


/**
 通过iImageIO的方式处理大图片

 @param data 图片数据
 @param size 目标size
 @param scale 屏幕比例
 @param orientation 图片放心
 @return 图片
 */
+ (UIImage *)scaledImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;

@end


