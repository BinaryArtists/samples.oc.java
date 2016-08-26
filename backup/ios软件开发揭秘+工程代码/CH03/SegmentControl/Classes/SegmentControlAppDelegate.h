//
//  SegmentControlAppDelegate.h
//  SegmentControl
//
//  Created by Henry Yu on 10-11-30.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentControlAppDelegate : NSObject <UIApplicationDelegate> {
	UIView *customView;
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

