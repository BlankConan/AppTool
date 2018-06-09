//
//  RootVC.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/5.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "RootVC.h"
#import "DatabaseTool.h"


@interface RootVC ()

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    [DatabaseTool initDB];
}


@end
