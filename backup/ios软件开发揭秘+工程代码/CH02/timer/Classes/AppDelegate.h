//
//  AppDelegate.h
//   timer
//
//  Created by Henry Yu on 10-03-24.
//  Copyright 2011 Sevensoft Inc. http://www.sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	id timer;
	UIProgressView *progressView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property(nonatomic, retain) UIProgressView *progressView;

@end

