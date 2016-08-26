//
//  AppDelegate.m
//  UISplitViewBasic
//
//  Created by Henry Yu on 5/18/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "AppDelegate.h"


#import "RootViewController.h"
#import "DetailViewController.h"


@implementation AppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    UIDevice *device = [UIDevice currentDevice];	
	[device beginGeneratingDeviceOrientationNotifications];	
	if ( ([device orientation] == UIDeviceOrientationLandscapeLeft) ||
		([device orientation] == UIDeviceOrientationLandscapeRight) )
	{
	    NSLog(@"Using landscape mode");
	}
	else
	{
		NSLog(@"Using portrait mode.");
	}	
	[device endGeneratingDeviceOrientationNotifications];
	
    // Add the split view controller's view to the window and display.		
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}


@end

