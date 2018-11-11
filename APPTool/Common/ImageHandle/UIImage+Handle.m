//
//  UIImage+Handle.m
//  APPTool
//
//  Created by liugangyi on 2018/11/8.
//  Copyright © 2018 liu gangyi. All rights reserved.
//

#import "UIImage+Handle.h"

@implementation UIImage (Handle)

- (UIImage *)scaleImage:(UIImage *)image newSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *destinationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destinationImage;
}

+ (UIImage *)scaledImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    
    CGFloat maxSize = MAX(size.width, size.height);
    CGImageSourceRef ref = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    
    NSDictionary  *options = @{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways : (__bridge id)kCFBooleanTrue,
                               (__bridge id)kCGImageSourceThumbnailMaxPixelSize:@(maxSize)
                               };
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(ref, 0, (__bridge CFDictionaryRef)options);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(ref);
    
    return image;
}

@end
