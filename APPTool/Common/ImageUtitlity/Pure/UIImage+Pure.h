//
//  UIImage+Pure.h
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Pure)


/**
 生成纯色图片

 @param imageSize 图片大小
 @param pureColor 图片颜色
 @return 纯色图片
 */
+ (UIImage *)pureImageWithSize:(CGSize)imageSize color:(UIColor *)pureColor;



@end

