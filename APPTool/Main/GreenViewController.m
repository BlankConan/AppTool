//
//  GreenViewController.m
//  APPTool
//
//  Created by liu gangyi on 2018/7/30.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "GreenViewController.h"


@interface GreenViewController ()

@end

@implementation GreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];

    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
    NSLog(@"释放了%@", [self class]);
}


@end
