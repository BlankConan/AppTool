//
//  NSString+Size.m
//  APPTool
//
//  Created by liugangyi on 2018/11/10.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)sizeWithFontCompatible:(UIFont *)font {
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width
                   lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
        
        CGRect stringRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        CGFloat widthResult = stringRect.size.width;
        if(widthResult - width >= 0.0000001)
        {
            widthResult = width;
        }
        
        return CGSizeMake(widthResult, ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font forWidth:width lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size {
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGRect stringRect = [self boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:size];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size
                   lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
        CGRect stringRect = [self boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (void)drawAtPointCompatible:(CGPoint)point withFont:(UIFont *)font {
    if([self respondsToSelector:@selector(drawAtPoint:withAttributes:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawAtPoint:point withAttributes:dictionaryAttributes];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font {
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawInRect:rect withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font
               lineBreakMode:(NSLineBreakMode)lineBreakMode
                   alignment:(NSTextAlignment)alignment {
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:alignment];
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,
                                               NSParagraphStyleAttributeName:paragraphStyle};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
#pragma clang diagnostic pop
    }
}

- (CGFloat)heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute fixedWidth:(CGFloat)width {
    
    NSParameterAssert(attribute);
    
    CGFloat height = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        
        height = rect.size.height;
    }
    
    return height;
}

- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    
    NSParameterAssert(attribute);
    
    CGFloat width = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        
        width = rect.size.width;
    }
    
    return width;
}


/**
 比较两个版本大小
 
 @param versionA 版本1
 @param versionB 版本2
 @return 返回YES说明前者大于后者
 */
- (BOOL)compareVersionA:(NSString *)versionA versionB:(NSString *)versionB {
    
    int numA = 0, numB = 0, indexA = 0, indexB = 0;
    while (1) {
        if (indexA < versionA.length) {
            while (1) {
                int character = [versionA characterAtIndex:indexA];
                ++indexA;
                if (character >= 48 && character <= 57) {
                    numA = character;
                    break;
                }
            }
        } else {
            numA = -1;
        }
        if (indexB < versionB.length) {
            while (1) {
                int character = [versionB characterAtIndex:indexB];
                ++indexB;
                if (character >= 48 && character <= 57) {
                    numB = character;
                    break;
                }
                
            }
        } else {
            numB = -1;
        }
        if (numA == numB && (numA != -1 || numB != -1)) {
            continue;
        } else {
            break;
        }
    }
    
    return numA > numB;
}


@end
