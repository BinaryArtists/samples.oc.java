//
//  BaseClass.m
//  InterfaceInherit
//
//  Created by Henry Yu on 10-11-06.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "BaseClass.h"


@implementation BaseClass

@synthesize delegate;

- (void)oldmethod{	
	[delegate oldmessage:@"BaseClass oldmethod called"];
}


@end
