//
//  PaletteAppDelegate.m
//  Palette
//
//  Created by Henry Yu on 10-11-15.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "PaletteAppDelegate.h"
#import "ColorPickerViewController.h"

@implementation PaletteAppDelegate

@synthesize window;
@synthesize button;

#pragma mark -
#pragma mark Application lifecycle
- (IBAction) showColorPickerViewController{
	
	viewController = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:nil];
	popover = [[UIPopoverController alloc] 
									initWithContentViewController:viewController];
	
    popover.popoverContentSize = viewController.view.frame.size;
    
	CGRect rect = CGRectMake(button.frame.origin.x+button.bounds.size.width, 
							 button.frame.origin.y, 20, 40);	
	
    [popover presentPopoverFromRect:rect 
                             inView:window 
           permittedArrowDirections:UIPopoverArrowDirectionLeft
	                        + UIPopoverArrowDirectionRight
						   animated:YES]; 	

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
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
	[viewController release];
	[popover release];
    [window release];
    [super dealloc];
}


@end
