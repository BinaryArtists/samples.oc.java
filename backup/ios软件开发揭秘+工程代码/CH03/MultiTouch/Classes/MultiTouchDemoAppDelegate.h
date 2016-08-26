//
//  MultiTouchDemoAppDelegate.h
//  MultiTouch
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiTouchDemoViewController;

@interface MultiTouchDemoAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet MultiTouchDemoViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) MultiTouchDemoViewController *viewController;

@end

