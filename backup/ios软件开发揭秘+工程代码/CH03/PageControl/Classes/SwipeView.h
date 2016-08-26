//
//  SwipeView.h
//  PageControl
//
//  Created by Henry Yu on 10-11-17.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SwipeView : UIView {
	CGPoint startTouchPosition;
	NSString *dirString;
	UIViewController *host;
}

- (void) setHost: (UIViewController *) aHost;

@end