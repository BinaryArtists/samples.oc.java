//
//  ControlDemoAppDelegate.m
//  TouchDemo
//
//  Created by Henry Yu on 6/4/09.
//  Copyright Sevenuc.com. 2009. All rights reserved.
//

#import "TouchDemoAppDelegate.h"
#import "TouchDemoViewController.h"

@implementation TouchDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
    [window addSubview:viewController.view];
	[window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
	[window release];
	[super dealloc];
}


@end
