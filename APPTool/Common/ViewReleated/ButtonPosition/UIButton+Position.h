//
//  UIButton+Position.h
//  Talent
//
//  Created by liugangyi on 2018/11/30.
//  Copyright © 2018年 TFN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  @brief button 上设置图片和文字位置和间距
 */
typedef NS_ENUM(NSInteger, LXMImagePosition) {
    /**
     *  图片在左，文字在右，默认
     */
    eLXMImagePositionLeft = 0,
    /**
     *  图片在右，文字在左
     */
    eLXMImagePositionRight = 1,
    /**
     *  图片在上，文字在下
     */
    eLXMImagePositionTop = 2,
    /**
     *  图片在下，文字在上
     */
    eLXMImagePositionBottom = 3,
};

@interface UIButton (Position)

/**
 @author houzhiwei, 16-05-11
 
 @brief Description
 
 @param postion 设置button上图片显示的位置
 @param spacing 间距
 
 @since ugc
 */
- (void)setImagePosition:(LXMImagePosition)postion spacing:(CGFloat)spacing;

/**
 
 @brief 设置图片显示的位置，不改变ControlState
 
 @param postion 设置button上图片显示的位置
 @param spacing 间距
 */
- (void)setImageOriginStatePosition:(LXMImagePosition)postion spacing:(CGFloat)spacing;

@end

NS_ASSUME_NONNULL_END
