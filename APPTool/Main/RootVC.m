//
//  RootVC.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/5.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "RootVC.h"
#import "DispatchTestVC.h"
#import "UIImage+Pure.h"

@interface RootVC ()


@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor orangeColor];
    UIImage *image = [UIImage pureImageWithSize:CGSizeMake(100, 100) color:[UIColor colorWithWhite:1 alpha:0.5]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    [self.view addSubview:imageView];
    [imageView setImage:image];
}







@end
