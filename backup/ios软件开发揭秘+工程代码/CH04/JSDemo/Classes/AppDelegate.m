//
//  AppDelegate.m
//  JSDemo
//
//  Created by Henry Yu on 10-11-08.
//  Copyright 2010 Sevenuc.com All rights reserved.
//

#import "AppDelegate.h"
#import "WebAgentView.h"

@implementation AppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
   
    // Override point for customization after application launch.
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	
	CGRect boxframe = CGRectMake(0, 44, screenWidth, screenHeight);
	WebAgentView *web = [[WebAgentView alloc] initWithFrame:boxframe];
	
	[window addSubview:web];
    [window makeKeyAndVisible];
	
	return YES;
}



- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
