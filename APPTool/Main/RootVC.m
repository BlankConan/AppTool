//
//  RootVC.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/5.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "RootVC.h"
#import "DispatchTestVC.h"
#import "TransitionAnimationDelegate.h"
#import "AnimationController.h"

@interface RootVC ()

@property (nonatomic, strong) TransitionAnimationDelegate *aaaa;

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.aaaa = [[TransitionAnimationDelegate alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    DispatchTestVC *vc = [[DispatchTestVC alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
    
    AnimationController *vc = [[AnimationController alloc] init];
    vc.transitioningDelegate = self.aaaa;
    [self presentViewController:vc animated:YES completion:nil];
}







@end
