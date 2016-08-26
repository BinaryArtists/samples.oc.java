//
//  AppDelegate.h
//  Splash
//
//  Created by Henry Yu on 1/14/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashViewController.h"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	SplashViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SplashViewController *viewController;

@end

