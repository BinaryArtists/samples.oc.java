//
//  test_appAppDelegate.m
//  test-app
//
//  Copyright Sevenuc.com All rights reserved.
//

#import "TestAppDelegate.h"
#import "ClassWithProtocol.h"

@implementation TestAppDelegate

@synthesize window;

- (void) processSuccessful:(BOOL)success
{
	NSLog(@"Process completed");
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{   
  // Create and initialize the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
	protocolTest = [[ClassWithProtocol alloc] init];
  [protocolTest setDelegate:self];
  [protocolTest startSomeProcess];
    
  [window makeKeyAndVisible];
  
}

- (void)dealloc 
{
  [window release];
  [super dealloc];
}

@end
