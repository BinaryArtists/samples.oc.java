//
//  AppDelegate.m
//  Splash
//
//  Created by Henry Yu on 1/14/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
 	viewController = [[SplashViewController alloc] init];
    // Override point for customization after app launch    
    [window addSubview:[viewController view]];	
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
