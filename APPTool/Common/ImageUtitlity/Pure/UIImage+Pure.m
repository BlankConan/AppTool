//
//  UIImage+Pure.m
//  APPTool
//
//  Created by liugangyi on 2018/11/12.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "UIImage+Pure.h"

@implementation UIImage (Pure)

+ (UIImage *)pureImageWithSize:(CGSize)imageSize color:(UIColor *)pureColor {
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [pureColor set];
    CGContextFillRect(ctx, CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
return image;
}

@end
