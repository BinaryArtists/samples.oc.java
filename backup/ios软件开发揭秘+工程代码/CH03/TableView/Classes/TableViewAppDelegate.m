//
//  TableViewAppDelegate.m
//  TableView
//
//  Created by Henry Yu on 10/21/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import "TableViewAppDelegate.h"
#import "TableViewController.h"

@implementation TableViewAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    viewController = [[TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.view.frame = [UIScreen mainScreen].applicationFrame;
    
    [window addSubview:viewController.view];
    
    // Override point for customization after application launch
    [window makeKeyAndVisible];
    
    
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
