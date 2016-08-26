//
//  MultiLineTextAppDelegate.h
//  MultiLineText
//
//  Created by Henry Yu on 3/29/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiLineTextAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

