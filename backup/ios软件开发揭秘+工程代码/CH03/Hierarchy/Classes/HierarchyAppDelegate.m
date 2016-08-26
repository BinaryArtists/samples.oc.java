//
//  HierarchyAppDelegate.m
//  Hierarchy
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "HierarchyAppDelegate.h"
#import "UIView+Hierarchy.h"

@implementation HierarchyAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle
- (void)showNext:(id)sender{
	UIImageView *view = nil;
	for(view in imageViews){
		if([view isInFront]){
			[view sentToBack];
			break;
		}
	} 	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	UIView *mainview = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	mainview.backgroundColor  = [UIColor clearColor];
		
	imageViews = [[NSMutableArray alloc] initWithCapacity:5];	
	for(int i = 1; i< 6; i++){	
		NSString *name = [NSString stringWithFormat:@"apple-ipad-background-%d.jpg",i];
		UIImage *image = [UIImage imageNamed:name];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = [[UIScreen mainScreen] bounds];
		[imageViews addObject:imageView];	
		[mainview addSubview:imageView];
		[imageView release];		
	}
	
	[window addSubview: mainview];
	[mainview release];
	
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setTitle:@"Show Next Picture" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(showNext:) forControlEvents:UIControlEventTouchUpInside];
	button.frame = CGRectMake(160-75, 480-44, 150, 40);
	button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	[window addSubview: button];		
	
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
