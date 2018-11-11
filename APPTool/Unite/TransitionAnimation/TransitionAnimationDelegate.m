//
//  TransitionAnimationDelegate.m
//  APPTool
//
//  Created by liu gangyi on 2018/9/13.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "TransitionAnimationDelegate.h"

@interface TransitionAnimationDelegate ()

@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation TransitionAnimationDelegate


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (fromVC) {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *snaptView = [toVC.view snapshotViewAfterScreenUpdates:YES];
        
        UIView *containerView = [transitionContext containerView];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        snaptView.frame = self.originalFrame;
        
        // 添加view
        [containerView addSubview:toVC.view];
        [containerView addSubview:snaptView];
        [toVC.view setHidden:YES];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
    
        // 添加动画
        [UIView animateWithDuration:0 animations:^{
            CATransition *transition = [[CATransition alloc] init];
            transition.duration = duration;
            transition.startProgress = 0;
            transition.endProgress = 1;
            transition.type = @"fade";
            [snaptView.layer addAnimation:transition forKey:nil];
        } completion:^(BOOL finished) {
            [toVC.view setHidden:NO];
            [snaptView removeFromSuperview];
            fromVC.view.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}



- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    
    
    return 2.0;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return self;
}

@end

