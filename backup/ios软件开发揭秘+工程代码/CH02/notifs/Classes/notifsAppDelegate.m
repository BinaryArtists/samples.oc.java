//  notifsAppDelegate.m
//
//  Copyright 2010 Sevenuc.com. All rights reserved. 
//
#import "notifsAppDelegate.h"
#import "SomeClass.h"

// For name of notification
NSString * const NOTIF_DataComplete = @"DataComplete";

@implementation notifsAppDelegate
@synthesize window;

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
  [window makeKeyAndVisible];
  
  SomeClass *someclass = [[SomeClass alloc] init];
  SomeClass *someclass2 = [[SomeClass alloc] init];
	
  NSLog(@"Begin Notification,Time:%@",[NSDate date]);	
  //...At some point, post a notification that the data has been downloaded  
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_DataComplete object:nil];
	
  NSLog(@"End Notification,Time:%@",[NSDate date]);

}


- (void)dealloc 
{
  [window release];
  [super dealloc];
}


@end
