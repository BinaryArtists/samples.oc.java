//
//  MultiTouchDemoAppDelegate.m
//  MultiTouch
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "MultiTouchDemoAppDelegate.h"
#import "MultiTouchDemoViewController.h"

@implementation MultiTouchDemoAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{	
    [window addSubview:viewController.view];
	[window makeKeyAndVisible];
}

- (void)dealloc
{
    [viewController release];
	[window release];
	[super dealloc];
}

@end
