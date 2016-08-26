//
//  HierarchyAppDelegate.h
//  Hierarchy
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HierarchyAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIButton *button;
	NSMutableArray *imageViews;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void)showNext:(id)sender;

@end

