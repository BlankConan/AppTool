//
//  RootVC.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/5.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "RootVC.h"
#import "DatabaseTool.h"
#import "GreenViewController.h"
#import "ExampleResponderVC.h"
@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    GreenViewController *greenvc = [[GreenViewController alloc] init];

    [self presentViewController:greenvc animated:YES completion:nil];
    
    
    // 响应链测试
//    ExampleResponderVC *vc = [[ExampleResponderVC alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
}

+ (void)timeRun:(NSTimer *)timer {
    NSLog(@"timer事件  %@", NSThread.currentThread);
}



@end
