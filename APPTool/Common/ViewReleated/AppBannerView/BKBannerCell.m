//
//  BKBannerCell.m
//  APPTool
//
//  Created by liugangyi on 2018/11/19.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKBannerCell.h"

@interface BKBannerCell ()
/// 图片容器.
@property (nonatomic, strong) UIImageView *imageView;
/// title.
@property (nonatomic, strong) UILabel *titleLab;

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
    
    self.imageView.frame = self.bounds;
    [self.contentView addSubview:self.imageView];
    
    self.titleLab.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30);
    [self.contentView addSubview:self.titleLab];
}

#pragma mark - Lazy

- (void)setModel:(BKBannerModel *)model {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.urlString]
                      placeholderImage:nil
                               options:SDWebImageRetryFailed
                             completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    self.titleLab.text = model.urlString;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.backgroundColor = [UIColor orangeColor];
    }
    return _titleLab;
}

@end
