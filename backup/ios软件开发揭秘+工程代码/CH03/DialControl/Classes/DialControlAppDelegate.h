//
//  DialControlAppDelegate.h
//  DialControl
//
//  Created by Henry Yu on 10-11-27.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialControlAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController* navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController* navigationController;

@end

