//
//  BKBanner.h
//  APPTool
//
//  Created by liugangyi on 2018/11/19.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BKBannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface BKBanner : UIView

- (instancetype)initWithModelArray:(NSArray<BKBannerModel *> *)bannerModelArray;

@end

NS_ASSUME_NONNULL_END
