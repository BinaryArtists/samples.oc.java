//
//  MyManager.m
//  singleton
//
//  Created by Henry Yu on 10-11-01.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "MyManager.h"

static MyManager *sharedMyManager = nil;

@implementation MyManager

+ (id)instance {
	if(sharedMyManager == nil)
		sharedMyManager = [[super alloc] init];
    return sharedMyManager;	
}

- (void)test{
	NSLog(@"%@",self);
}

- (void)dealloc {
	[super dealloc];
}

@end
