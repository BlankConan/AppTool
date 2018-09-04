//
//  DispatchTestVC.m
//  APPTool
//
//  Created by liu gangyi on 2018/9/3.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

/**
 队列：
    1. 串行队列 FIFO，使用一个线程。比如：主队列，和创建额串行队列
    2. 并发队列 不分先后顺序，使用多个线程。比如：全局队列和创建的并发队列
 
 异步：不会等待任务完成情况，不会阻塞线程
 同步：等待任务结束，会阻塞线程
 
 */

#import "DispatchTestVC.h"
#import "AFNetworking.h"
#import <asl.h>

@interface DispatchTestVC ()

@property (nonatomic, strong) UIButton *queueAsyncBtn;
@property (nonatomic, strong) UIButton *queueSyncBtn;
@property (nonatomic, strong) UIButton *groupGCDBtn;
@property (nonatomic, strong) UIButton *barrierBtn;
@property (nonatomic, strong) UIButton *targetQueueBtn;

@end

@implementation DispatchTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.queueAsyncBtn.frame = CGRectMake(20, 100, 150, 30);
    self.queueSyncBtn.frame = CGRectMake(CGRectGetMaxX(self.queueAsyncBtn.frame)+20, 100, 150, 30);
    
    self.groupGCDBtn.frame = CGRectMake(20, CGRectGetMaxY(self.queueAsyncBtn.frame)+20, 150, 30);
    self.barrierBtn.frame = CGRectMake(CGRectGetMaxX(self.groupGCDBtn.frame)+20, CGRectGetMinY(self.groupGCDBtn.frame), 150, 30);
    
    self.targetQueueBtn.frame = CGRectMake(20, CGRectGetMaxY(self.groupGCDBtn.frame)+20, 150, 30);
}

#pragma mark - 异步同步 串行和并行
// 异步
- (void)queueAsync {
    
    // YES：串行 NO：并行
    BOOL isSerialQueue = YES;
    dispatch_queue_t queue = nil;
    isSerialQueue ? (queue = dispatch_queue_create("com.liugangyi.www", DISPATCH_QUEUE_SERIAL)) : (queue = dispatch_queue_create("com.liugangyi.www", DISPATCH_QUEUE_CONCURRENT));
    
    dispatch_async(queue, ^{
        sleep(3);
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"1");
    });
    NSLog(@"1.5");
    
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"2");
    });
    NSLog(@"2.5");
    
    dispatch_async(queue, ^{
        NSLog(@"3");
        NSLog(@"%@", [NSThread currentThread]);
    });
    
    NSLog(@"3.5");
    
    dispatch_async(queue, ^{
        sleep(1);
        NSLog(@"%@", [NSThread currentThread]);
        NSLog(@"4");
    });
    NSLog(@"4.5");
}

// 同步
- (void)queueSync {
    
    // YES：串行 NO：并行
    BOOL isSerialQueue = YES;
    
    dispatch_queue_t queue = nil;
    isSerialQueue ? (queue = dispatch_queue_create("com.liugangyiAA.www", DISPATCH_QUEUE_SERIAL)) : (queue = dispatch_queue_create("com.liugangyiBB.www", DISPATCH_QUEUE_CONCURRENT));
    
    dispatch_sync(queue, ^{
        sleep(3);
        NSLog(@"1");
    });
        NSLog(@"1.5");
    
    dispatch_sync(queue, ^{
        sleep(1);
        NSLog(@"2");
    });
        NSLog(@"2.5");
    
    dispatch_sync(queue, ^{
        NSLog(@"3");
    });
        NSLog(@"3.5");
    
    dispatch_sync(queue, ^{
        sleep(1);
        NSLog(@"4");
    });
        NSLog(@"4.5");
}

#pragma mark - Group

// 这个API一般和async使用
- (void)groupGCD {
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.liugangyiHH.www", DISPATCH_QUEUE_CONCURRENT);
    BOOL isQueue = NO;
    
    if (isQueue) {
        
        dispatch_group_async(group, concurrentQueue, ^{
            
            NSLog(@"1.1");
        });
        
        dispatch_group_async(group, concurrentQueue, ^{
            NSLog(@"2.2");
        });
        
        dispatch_group_async(group, concurrentQueue, ^{
            NSLog(@"3.3");
        });
        
        // 不会阻塞线程，异步回调
//        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//            NSLog(@"over");
//        });
        
        // 会阻塞线程
        if (dispatch_group_wait(group, DISPATCH_TIME_FOREVER) == 0) {
            NSLog(@"success");
        } else {
            NSLog(@"failed");
        }
        
        NSLog(@"Last");
    } else {
        
        // dispatch_group_enter(group)
        // dispatch_group_leave(group)
        // 这两个成对使用
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        dispatch_group_enter(group);
        dispatch_group_enter(group);
        dispatch_group_enter(group);
        
        dispatch_group_async(group, concurrentQueue, ^{
            [manager GET:@"www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"1");
                dispatch_group_leave(group);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"1");
                dispatch_group_leave(group);
            }];
        });
        
        dispatch_group_async(group, concurrentQueue, ^{
            [manager GET:@"www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"2");
                dispatch_group_leave(group);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"2");
                dispatch_group_leave(group);
            }];
        });
        
        dispatch_group_async(group, concurrentQueue, ^{
            [manager GET:@"www.baidu.com" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"3");
                dispatch_group_leave(group);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"3");
                dispatch_group_leave(group);
            }];
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"任务结束");
        });
        
        NSLog(@"是否阻塞");
    }
    
}

#pragma mark - barrier栅栏

- (void)dispatch_barrier {
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.asdfasdf.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2");
    });
   
    // sync 会阻塞线程；async不会阻塞线程，所以block会立即回调
    NSLog(@"栅栏前面");
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"等我干完这个");
    });
    NSLog(@"栅栏后面");
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"3");
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"4");
    });
}

#pragma mark - set target queue

/**
 1.可以变更执行的优先级
 2.执行阶层
 */
- (void)set_target_queue {
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.hhhh.www", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_set_target_queue(serialQueue, globalQueue);
    
}


#pragma mark - I/O


#pragma mark - 执行 Order 测试
// 测试队列执行顺序
- (void)testExcuteOrder {
    
    NSLog(@"0");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1");
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"2");
        });
        NSLog(@"3");
    });
    NSLog(@"Over");
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    

    
}



#pragma mark - setter & getter

- (UIButton *)queueAsyncBtn {
    
    if (!_queueAsyncBtn) {
        _queueAsyncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queueAsyncBtn addTarget:self action:@selector(queueAsync) forControlEvents:UIControlEventTouchUpInside];
        _queueAsyncBtn.backgroundColor = [UIColor orangeColor];
        [_queueAsyncBtn setTitle:@"queueAsync" forState:UIControlStateNormal];
        [self.view addSubview:_queueAsyncBtn];
    }
    return _queueAsyncBtn;
}

- (UIButton *)queueSyncBtn {
    
    if (!_queueSyncBtn) {
        _queueSyncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queueSyncBtn addTarget:self action:@selector(queueSync) forControlEvents:UIControlEventTouchUpInside];
        _queueSyncBtn.backgroundColor = [UIColor orangeColor];
        [_queueSyncBtn setTitle:@"queueSync" forState:UIControlStateNormal];
        [self.view addSubview:_queueSyncBtn];
    }
    return _queueSyncBtn;
}

- (UIButton *)groupGCDBtn {
    
    if (!_groupGCDBtn) {
        _groupGCDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _groupGCDBtn.backgroundColor = [UIColor greenColor];
        [_groupGCDBtn setTitle:@"GroupGCD" forState:UIControlStateNormal];
        [self.view addSubview:_groupGCDBtn];
        [_groupGCDBtn addTarget:self action:@selector(groupGCD) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupGCDBtn;
}

- (UIButton *)barrierBtn {
    
    if (!_barrierBtn) {
        _barrierBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _barrierBtn.backgroundColor = [UIColor greenColor];
        [_barrierBtn setTitle:@"Barrier" forState:UIControlStateNormal];
        [self.view addSubview:_barrierBtn];
        [_barrierBtn addTarget:self action:@selector(dispatch_barrier) forControlEvents:UIControlEventTouchUpInside];
    }
    return _barrierBtn;
}

- (UIButton *)targetQueueBtn {
    
    if (!_targetQueueBtn) {
        _targetQueueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _targetQueueBtn.backgroundColor = [UIColor orangeColor];
        [_targetQueueBtn setTitle:@"Queue_Target" forState:UIControlStateNormal];
        [self.view addSubview:_targetQueueBtn];
        [_targetQueueBtn addTarget:self action:@selector(set_target_queue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _targetQueueBtn;
}


@end
