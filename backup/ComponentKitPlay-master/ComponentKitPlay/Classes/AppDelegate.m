//
//  AppDelegate.m
//
//
//  Created by xiekw on 15/3/24.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "AppDelegate.h"
#import "CPCollectionViewController.h"
#import "CPTableViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    CPTableViewController *tableVC = [CPTableViewController new];
    CPCollectionViewController *collectionVC = [CPCollectionViewController new];
    tableVC.title = @"Table";
    collectionVC.title = @"Collection";
    
    tbc.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:tableVC], [[UINavigationController alloc] initWithRootViewController:collectionVC]];
    
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
