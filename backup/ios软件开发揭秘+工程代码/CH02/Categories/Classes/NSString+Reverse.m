//
//  NSString+Reverse.m
//  Categories
//
//  Created by Henry Yu on 10-11-02.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "NSString+Reverse.h"

@implementation NSString (reverse)

-(NSString *)reverseString
{
	NSMutableString *reversedStr;
	int len = [self length];
	
	// Auto released string
	reversedStr = [NSMutableString stringWithCapacity:len];     
	
	// Probably woefully inefficient...
	while (len > 0)
		[reversedStr appendString: [NSString stringWithFormat:@"%C", [self characterAtIndex:--len]]];   
	
	return reversedStr;
}
@end
