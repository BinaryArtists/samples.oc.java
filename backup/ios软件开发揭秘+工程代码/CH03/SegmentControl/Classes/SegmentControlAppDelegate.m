//
//  SegmentControlAppDelegate.m
//  SegmentControl
//
//  Created by Henry Yu on 10-11-30.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SegmentControlAppDelegate.h"

#define kPaletteHeight			30
#define kPaletteSize			5
#define kMinEraseInterval		0.5

// Padding for margins
#define kLeftMargin				10.0
#define kTopMargin				10.0
#define kRightMargin			10.0

@implementation SegmentControlAppDelegate

@synthesize window;

- (void)changeBrushColor:(id)sender{
 	
	//Set the new brush color
	UIColor *currentColor = [UIColor redColor];
	switch([sender selectedSegmentIndex]){
		case 0:
			currentColor = [UIColor redColor];
			break;
		case 1:
			currentColor = [UIColor yellowColor];
			break;
		case 2:
			currentColor = [UIColor greenColor];
			break;
		case 3:
			currentColor = [UIColor blueColor];
			break;
		case 4:
			currentColor = [UIColor purpleColor];
			break;		
		default:
			break;
	}
 		
	customView.backgroundColor = currentColor;
	
}

- (void) initSegmentedControl{
	CGRect				rect = [[UIScreen mainScreen] applicationFrame];
		
	// Create a segmented control so that the user can choose the brush color.
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
											[NSArray arrayWithObjects:
											 [UIImage imageNamed:@"Red.png"],
											 [UIImage imageNamed:@"Yellow.png"],
											 [UIImage imageNamed:@"Green.png"],
											 [UIImage imageNamed:@"Blue.png"],
											 [UIImage imageNamed:@"Purple.png"],
											 nil]];
	
	CGRect frame = CGRectMake(kLeftMargin, 
							  rect.size.height - kTopMargin, 
							  rect.size.width - (kLeftMargin + kRightMargin), kPaletteHeight);
	
	segmentedControl.frame = frame;
	// When the user chooses a color, the method changeBrushColor: is called.
	[segmentedControl addTarget:self action:@selector(changeBrushColor:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	// Make sure the color of the color complements the black background
	segmentedControl.tintColor = [UIColor darkGrayColor];
	// Set the third color (index values start at 0)
	segmentedControl.selectedSegmentIndex = 2;
	
	// Add the control to the window
	[window addSubview:segmentedControl];
	[segmentedControl release];				
	
}



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	customView = [[UIView alloc] initWithFrame:CGRectMake((320-120)/2, (480-120)/2, 120, 120)];
	customView.backgroundColor = [UIColor whiteColor];
	[window addSubview:customView];
	[customView release];
	
    [self initSegmentedControl];
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
