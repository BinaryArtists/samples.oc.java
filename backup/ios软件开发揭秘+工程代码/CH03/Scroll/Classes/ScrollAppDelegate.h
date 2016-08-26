//
//  ScrollAppDelegate.h
//  Scroll
//
//  Created by Henry Yu on 11/19/10.
//  Copyright Sevenuc.com. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollAppDelegate : NSObject <UIApplicationDelegate, UIScrollViewDelegate> {
    UIWindow *window;
    UIScrollView *scrollView;
    UIView *containerView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

