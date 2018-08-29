//
//  GreenViewController.m
//  APPTool
//
//  Created by liu gangyi on 2018/7/30.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "GreenViewController.h"
#import "RootVC.h"
@interface GreenViewController ()



@end

@implementation GreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view.

    ^{
        
      
    };

}


- (void)viewWillDisappear:(BOOL)animated {

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    
    NSLog(@"释放了");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
