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
UIScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) BKTimer *timer;
@property (nonatomic, strong) UICollectionView *container;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL isDraging;
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

#pragma mark - ScrollerView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetContentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDraging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    _isDraging = NO;
}

#pragma mark - CollectionView Delegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BKBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if (_bannerModelArray.count == 1) {
        cell.model = self.bannerModelArray[indexPath.row];
    } else {
        // oxxxo 三个元素 两个空位
        if (indexPath.row == 0) { // 第一个
            cell.model = [self.bannerModelArray lastObject];
        } else if (indexPath.row == self.bannerModelArray.count + 1) {
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.container setFrame:self.bounds];
    [self.container reloadData];
    if (self.bannerModelArray.count > 1) {
        [self.container scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark Target Action

- (void)loopAction {
    if (_isDraging) return;
    
}

#pragma mark - Assistan method

- (void)resetContentOffset {
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGPoint contentOffset = self.container.contentOffset;
    NSInteger currentIndex = contentOffset.x / width;
    // 原理，元素对应，更新下标(x:元素 o:填充物)
    // 0 1 2 3 4 下标
    // 9 5 8 9 5 元素内容
    // o x x x o
    // 切换下标，重置偏移量
    if (currentIndex == self.bannerModelArray.count + 1) {
        currentIndex = 1;
    } else if (currentIndex == 0) {
        currentIndex = self.bannerModelArray.count;
    }
    
    [self.container setContentOffset:CGPointMake(currentIndex * width, 0) animated:NO];
}

- (void)updatePageControl {
    
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
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _container = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _container.backgroundColor = [UIColor whiteColor];
        _container.delegate = self;
        _container.dataSource = self;
        _container.pagingEnabled = YES;
        _container.bounces = NO;
        _container.showsHorizontalScrollIndicator = NO;
        [_container registerClass:[BKBannerCell class] forCellWithReuseIdentifier:cellID];
        [self addSubview:_container];
    }
    return _container;
}




@end
