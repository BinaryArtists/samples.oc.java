//
//  VocabularyAppDelegate.m
//  Vocabulary
//
//  Created by Henry Yu on 10/21/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "VocabularyAppDelegate.h"
#import "WordListTableViewController.h"

@implementation VocabularyAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    WordListTableViewController *wltvc = [[WordListTableViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] init];
	[nav pushViewController:wltvc animated:NO];
	[wltvc release];
	[window addSubview:nav.view];

    [window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
    [window release];
    [super dealloc];
}


@end
