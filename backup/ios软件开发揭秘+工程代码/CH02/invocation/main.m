//
//  main.m
//  invocation
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "SomeClass.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
   		
	SomeClass *obj = [[SomeClass alloc] init];
	[obj commonOperation];
	[obj improvedOperation];
		
	[obj release];
    [pool release];
    return 0;
}
