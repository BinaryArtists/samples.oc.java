//
//  UIViewBasicAppDelegate.h
//  UIViewBasic
//
//  Created by Henry Yu on 10-11-13.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewBasicAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIView* slideView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction)slideShow:(id)sender;

@end

