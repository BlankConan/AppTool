//
//  BKBanner.m
//  APPTool
//
//  Created by liugangyi on 2018/11/19.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BKBanner.h"
#import "BKBannerModel.h"
#import "BKTimer.h"
#import "BKBannerCell.h"

static NSString *cellID = @"BKBannerCell";

@interface BKBanner ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong) BKTimer *timer;
@property (nonatomic, strong) UICollectionView *container;
@property (nonatomic, assign) BOOL isFirstLoad;
@end

@implementation BKBanner

#pragma mark Init

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithModelArray:(NSArray<BKBannerModel *> *)bannerModelArray {
    self = [self init];
    if (self) {
        self.bannerModelArray = bannerModelArray;
    }
    return self;
}

#pragma mark - Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BKBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (_bannerModelArray.count == 1) {
        cell.model = self.bannerModelArray[indexPath.row];
    } else {
        // oxxxo 三个元素 两个空位
        if (indexPath.row == 0) { // 第一个
            cell.model = [self.bannerModelArray lastObject];
        } else if (indexPath.row == self.bannerModelArray.count - 1) {
            cell.model = [self.bannerModelArray firstObject];
        } else {
            cell.model = self.bannerModelArray[indexPath.row - 1];
        }
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (_bannerModelArray.count < 2) {
        return _bannerModelArray.count;
    }
    return _bannerModelArray.count + 2;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.container reloadData];
}

#pragma mark Target Action

- (void)loopAction {
    
}

#pragma mark - Assistan method

- (void)reloadData {
    
}


#pragma mark - setter & getter

- (void)setBannerModelArray:(NSArray *)bannerModelArray {
    _bannerModelArray = bannerModelArray;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (BKTimer *)timer {
    
    if (!_timer) {
        _timer = [BKTimer timerWithTimeInterval:3 target:self selector:@selector(loopAction) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UICollectionView *)container {
    
    if (!_container) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _container = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _container.backgroundColor = [UIColor whiteColor];
        _container.delegate = self;
        _container.dataSource = self;
        _container.pagingEnabled = YES;
        _container.bounces = NO;
        [_container registerClass:[BKBannerCell class] forCellWithReuseIdentifier:cellID];
        [self addSubview:_container];
    }
    return _container;
}




@end
