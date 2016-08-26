//
//  SubClass.m
//  InterfaceInherit
//
//  Created by Henry Yu on 10-11-06.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SubClass.h"

@implementation SubClass

- (void)oldmethod{
	[delegate oldmessage:@"SubClass oldmethod called"];
}

- (void)newmethod:(NSString *)str{
	[delegate oldmessage:@"SubClass newmethod called"];	
	[delegate newmessage:@"SubClass newmethod called"];
}

@end
