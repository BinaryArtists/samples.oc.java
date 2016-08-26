//
//  AppDelegate.m
//   timer
//
//  Created by Henry Yu on 10-03-24.
//  Copyright 2011 Sevensoft Inc. http://www.sevenuc.com. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#define DOWNLOAD_TIMEOUT    60.0
static	CGFloat amt = 0.0;

@synthesize window;
@synthesize progressView;

#pragma mark -
#pragma mark Application lifecycle

- (void) handleTimer: (id)atimer { 
	amt += 1;
	if(progressView != nil)
		[progressView setProgress: (amt / DOWNLOAD_TIMEOUT)];
	if (amt > DOWNLOAD_TIMEOUT) {
		[atimer invalidate];
		atimer = nil;
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    
	 timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
											  target: self 
											selector: @selector(handleTimer:)
											userInfo: nil
											 repeats: YES];
	
	progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
	[window addSubview:progressView];
	[progressView setProgressViewStyle: UIProgressViewStyleBar];
	[progressView release];
    [window makeKeyAndVisible];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
