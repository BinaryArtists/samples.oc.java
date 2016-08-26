//
//  ButtonAppDelegate.h
//  Button
//
//  Created by Henry Yu on 10-11-14.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIButton *button;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIButton *button;

@end

