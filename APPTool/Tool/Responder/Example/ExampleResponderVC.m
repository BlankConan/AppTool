
//
//  ExampleResponderVC.m
//  APPTool
//
//  Created by liu gangyi on 2018/8/20.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "ExampleResponderVC.h"
#import "GreenView.h"
#import "RedView.h"

@interface ExampleResponderVC ()

{
    NSString *_name;
}

@property (nonatomic, strong) GreenView *greenV;
@property (nonatomic, strong) RedView *redV;
@property (nonatomic, copy) NSString *name;
@end



@implementation ExampleResponderVC

@synthesize name = _name;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.greenV.frame = CGRectMake(100, 100, 200, 100);
    self.redV.frame = CGRectMake(100, 400, 200, 100);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (GreenView *)greenV {
    if (!_greenV) {
        _greenV = [[GreenView alloc] init];
        [self.view addSubview:_greenV];
    }
    return _greenV;
}

- (RedView *)redV {
    if (!_redV) {
        _redV = [[RedView alloc] init];
        [self.view addSubview:_redV];
    }
    return _redV;
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
