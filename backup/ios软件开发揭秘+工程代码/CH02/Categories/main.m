//
//  main.m
//  Categories
//
//  Created by Henry Yu on 10-11-02.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Reverse.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
	NSString *str  = [NSString stringWithString:@"Foobar"];
	NSString *rev;
	
	NSLog(@"String: %@", str);	
	rev = [str reverseString];	
	NSLog(@"Reversed: %@",rev); 	
	
    [pool release];
    return 0;
}
