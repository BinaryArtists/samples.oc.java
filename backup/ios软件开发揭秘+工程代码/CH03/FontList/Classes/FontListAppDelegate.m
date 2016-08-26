//
//  FontListAppDelegate.m
//  FontList
//
//  Created by Henry Yu on 11/17/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import "FontListAppDelegate.h"
#import "RootViewController.h"


@implementation FontListAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
