//
//  BaseNavigationController.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/5.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "BaseNavigationController.h"
#import "AppBaseVC.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark Pop/push

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
   return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
   return [super popToViewController:viewController animated:animated];
}



@end
