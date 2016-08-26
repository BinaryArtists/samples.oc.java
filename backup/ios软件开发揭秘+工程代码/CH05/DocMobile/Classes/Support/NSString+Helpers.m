//
//  NSString+Helpers.m
//  
//  Created by Henry Yu on 09-09-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  
//

#import "NSString+Helpers.h"
#import "NSData+Base64.h"

@implementation NSString (Helpers)

#pragma mark Helpers
- (NSString *) stringByUrlEncoding
{
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)self,  NULL,  (CFStringRef)@"!*'();:@&=+$,/?%#[]",  kCFStringEncodingUTF8);
}

- (NSString *)base64Encoding
{
	NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
	NSString *encodedString = [stringData base64EncodedString:0];

	return encodedString;
}

@end