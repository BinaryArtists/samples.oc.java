//
//  TouchDemoAppDelegate.h
//  TouchDemo
//
//  Created by Henry Yu on 6/4/09.
//  Copyright Sevenuc.com. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchDemoViewController;

@interface TouchDemoAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet TouchDemoViewController *viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) TouchDemoViewController *viewController;

@end

