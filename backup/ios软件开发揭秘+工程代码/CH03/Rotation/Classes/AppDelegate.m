//
//  AppDelegate.m
//  Rotation
//
//  Created by Henry Yu on 11/19/10.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "AppDelegate.h"

UILabel *label;
float elapsedTime = 0;

@implementation AppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	// Retrieve the text and colors from file
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
	imageView.frame = [[UIScreen mainScreen] bounds];
	[window addSubview:imageView];		
	[imageView release];		
	
	label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, 30.0f)];
	label.text = @"hello, world!";
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize: 26];
	
	[NSTimer scheduledTimerWithTimeInterval: 0.1/60 target: self selector:@selector(dummyFrame) userInfo:nil repeats:YES];
	[window addSubview: label];
	[label release];
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void) dummyFrame {
	elapsedTime += 1.0 / 60.0f;
	CGAffineTransform t = CGAffineTransformMakeScale(1 + sin(elapsedTime * 2) * .5, 1 + sin(elapsedTime * 2) * .5);
	t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(sin(elapsedTime / 1.5)));
	t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(0, window.center.y + .3 * window.frame.size.height * cos(elapsedTime / 2.0)));
	label.transform = t;
	
//	label.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(sin(elapsedTime / 1.5)), CGAffineTransformMakeTranslation(0, window.center.y + .3 * window.frame.size.height * cos(elapsedTime / 2.0)));
	window.backgroundColor = [UIColor colorWithRed: .4 + fabs(sin(elapsedTime)) * .6
											green: .6 + fabs(sin(elapsedTime)) * .4
											blue: .8 + fabs(sin(elapsedTime)) * .2
										   alpha: 1.0f];
 			
	
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
