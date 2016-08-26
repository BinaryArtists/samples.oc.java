//
//  main.m
//  MethodSwizzle
//
//  Created by Henry Yu on 10-11-05.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//


#import "Swizzle.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	Swizzle *obj = [[Swizzle alloc] init];
	[obj testSwizzle];	

	[obj release];
    [pool release];
    return 0;
}
