//
//  BKBanner.h
//  APPTool
//
//  Created by liugangyi on 2018/11/19.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BKBannerModel;

@protocol BKBannerDelegate <NSObject>

@optional
/// tap banner.
- (void)bannerActionWithModel:(BKBannerModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BKBanner : UIView
/// 数据容器.
@property (nonatomic, strong) NSArray *bannerModelArray;
/// 点击回调block.
@property (nonatomic, copy) void (^tapAction)(BKBannerModel *model);
@property (nonatomic, weak) id<BKBannerDelegate> delegate;

/// 通过模型数组初始化.
- (instancetype)initWithModelArray:(NSArray<BKBannerModel *> *)bannerModelArray;

@end

NS_ASSUME_NONNULL_END
