//
//  AppDelegate.m
//  APPTool
//
//  Created by liu gangyi on 2018/6/5.
//  Copyright © 2018年 liu gangyi. All rights reserved.
//

#import "AppDelegate.h"
#import "RootVC.h"
#import "NSObject+Runtime.h"
#import <objc/runtime.h>
#import "UIControl+Statics.h"
@interface AppDelegate ()
{
    NSString *_ssss;
}
@property (nonatomic, strong) NSString *nameA;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[RootVC alloc] init];
    [self.window makeKeyAndVisible];
    
    if ([self compareVersionA:@"1.2.2" versionB:@"1.2"]) {
        NSLog(@"第一个大于第二个");
    } else {
        NSLog(@"第二个大于第一个");
    }
    
    return YES;
}


/**
 比较两个版本大小
 
 @param versionA 版本1
 @param versionB 版本2
 @return 返回YES说明前者大于后者
 */
- (BOOL)compareVersionA:(NSString *)versionA versionB:(NSString *)versionB {
    
    int numA = 0, numB = 0, indexA = 0, indexB = 0;
    while (1) {
        if (indexA < versionA.length) {
            while (1) {
                int character = [versionA characterAtIndex:indexA];
                ++indexA;
                if (character >= 48 && character <= 57) {
                    numA = character;
                    break;
                }
            }
        } else {
            numA = -1;
        }
        if (indexB < versionB.length) {
            while (1) {
                int character = [versionB characterAtIndex:indexB];
                ++indexB;
                if (character >= 48 && character <= 57) {
                    numB = character;
                    break;
                }
                
            }
        } else {
            numB = -1;
        }
        if (numA == numB && (numA != -1 || numB != -1)) {
            continue;
        } else {
            break;
        }
    }
    
    return numA > numB;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
