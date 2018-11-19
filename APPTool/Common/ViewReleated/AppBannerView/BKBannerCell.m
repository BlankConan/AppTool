//
//  BKBannerCell.m
//  APPTool
//
//  Created by liugangyi on 2018/11/19.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKBannerCell.h"

@interface BKBannerCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end



@implementation BKBannerCell


#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}


#pragma mark - Private

- (void)setupViews {
    
    [self.contentView addSubview:self.imageView];
}

#pragma mark - Lazy

- (void)setModel:(BKBannerModel *)model {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.urlString]
                      placeholderImage:nil
                               options:SDWebImageRetryFailed
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

@end
