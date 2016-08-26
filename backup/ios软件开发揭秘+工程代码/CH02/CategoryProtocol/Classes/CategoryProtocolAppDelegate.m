//
//  CategoryProtocolAppDelegate.m
//  CategoryProtocol
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "CategoryProtocolAppDelegate.h"
#import "SomeClass.h"

@implementation CategoryProtocolAppDelegate


- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
      
	SomeClass *obj = [[SomeClass alloc] init];
	[obj method];
		
	return YES;
}

- (void)dealloc {    
    [super dealloc];
}


@end
