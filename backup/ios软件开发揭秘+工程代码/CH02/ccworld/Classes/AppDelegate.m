//
//  AppDelegate.m
//  ccworld
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "AppDelegate.h"
#import "CCAgent.h"

@implementation AppDelegate

- (void)renderCompleted:(NSString *)msg{
	NSLog(@"%@",msg);
}

- (BOOL)application:(UIApplication *)application
   didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	agent = [[CCAgent alloc] init];
	agent.delegate = self;
	[agent InitEngine];
	[agent StartEngine:@"String from Object-C"];
	[agent GetChannelList];		    
	
	return YES;
}

- (void)dealloc { 
	[agent release];
    [super dealloc];
}


@end
