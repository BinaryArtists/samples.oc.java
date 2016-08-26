//
//  UIViewBasicAppDelegate.m
//  UIViewBasic
//
//  Created by Henry Yu on 10-11-13.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "UIViewBasicAppDelegate.h"

@implementation UIViewBasicAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	//Case 1, create
	CGRect viewRect = CGRectMake(0, 0, 150, 50); 
	UIView *myView = [[UIView alloc] initWithFrame:viewRect];
	myView.backgroundColor = [UIColor redColor];
	
	//	[window addSubview:myView];
	
	//Case 2, move
	myView.frame = CGRectMake(100, 44, 150, 50);
	myView.center = CGPointMake(150, 94);
	//	[window addSubview:myView];
	
	//Case 3, rotate
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	myView.transform = CGAffineTransformMakeRotation(-1.57);
	CGContextRestoreGState(context);
	//	[window addSubview:myView];
	
	//Case 4, scale
	CGRect mainframe = CGRectMake(0, 0, 300, 100);
	myView.frame = mainframe;
	[window addSubview:myView];
		
	[myView release];	    
	
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)slidingMyView{	
	// Slide the view down off screen
	CGRect frame = slideView.frame;	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.75];
    if(frame.origin.y == 0)
		frame.origin.y = 480;		
	else
		frame.origin.y = 0;			
	slideView.frame = frame;	
	[UIView commitAnimations];
}


- (IBAction)slideShow:(id)sender{
	// Slide the view down off screen
	if(slideView == nil){
	    CGRect viewRect = CGRectMake(160, 0, 300, 100); 
	    slideView = [[UIView alloc] initWithFrame:viewRect];
	    slideView.backgroundColor = [UIColor blueColor];
		[window addSubview:slideView];
	}
	int delay = 0;	
	[self performSelector:@selector(slidingMyView) withObject:nil afterDelay:delay];
	
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
