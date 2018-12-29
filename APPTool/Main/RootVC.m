//
//  RootVC.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/5.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "RootVC.h"
#import "DispatchTestVC.h"

#import "BKBannerModel.h"
#import "BKBanner.h"
#import "UIButton+Position.h"


@interface RootVC ()


@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor orangeColor];
    
    NSArray *imageUrlStr = @[@"http://pic.ffpic.com/files/tupian/tupian0277.jpg",
                             @"https://ps.ssl.qhimg.com/dmfd/400_300_/t014a0fa0aa906012e8.jpg",
                             @"http://img95.699pic.com/photo/50038/1181.jpg_wh300.jpg",
                             @"http://www.shuoshuokong.com/uploads/allimg/161220/1-161220135105.jpg",
                             @"http://img.tupianzj.com/uploads/allimg/150628/10-15062R135260-L.jpg"];
    
    NSMutableArray *modelArr = [@[] mutableCopy];
    for (int i = 0; i < imageUrlStr.count; i++) {
        BKBannerModel *model = [[BKBannerModel alloc] init];
        model.urlString = imageUrlStr[i];
        model.isVideo = NO;
        [modelArr addObject:model];
    }
    
    BKBanner *banner = [[BKBanner alloc] initWithModelArray:modelArr];
    banner.backgroundColor = [UIColor whiteColor];
    banner.frame = CGRectMake(0, 64, PHONE_WIDTH, 280);
    [self.view addSubview:banner];
    banner.tapAction = ^(BKBannerModel * _Nonnull model) {
        NSLog(@"%@", model.urlString);
    };
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button setTitle:@"测试字划线" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    [button setFrame:CGRectMake(150, 200, 150, 30)];
    [self.view addSubview:button];
    
    
}







@end
