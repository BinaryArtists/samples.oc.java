//
//  SomeClass+Wrapper.m
//  CategoryProtocol
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SomeClass+Wrapper.h"

@implementation SomeClass (Wrapper)

- (void)private{
	NSLog(@"implement protocol in categories!");	
}

- (void)method {
	[self private];
}

@end
