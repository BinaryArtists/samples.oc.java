//
//  NSOperationTestAppDelegate.m
//  NSOperationTest
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "NSOperationTestAppDelegate.h"


@implementation NSOperationTestAppDelegate

-(void) longTaskOperationFinished:(LongTaskOperation*)op{
	NSLog(@"longTaskOperationFinished:%@",op);
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
   // Override point for customization after app launch    
	mQueue = [[NSOperationQueue alloc] init];	//empty queue
	// a good heuristic = processors + 1
	[mQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];	
		
	// Queue up an operation to do the work!
	LongTaskOperation *op = [[LongTaskOperation alloc] 
								initWithPath:@"the image path"];
	op.taskDelegate	= self;	//set the delegate
	[mQueue addOperation:op];
	[op release];
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	
}

	 
- (void)dealloc 
{
	// stop any pending operations
	[mQueue cancelAllOperations];
	[mQueue release];
	 mQueue	= nil;
	
    [super dealloc];
}


@end
