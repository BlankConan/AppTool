//
//  RedView.m
//  APPTool
//
//  Created by liu gangyi on 2018/8/20.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "RedView.h"

@implementation RedView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    debugLog(@"红色");
}


@end
