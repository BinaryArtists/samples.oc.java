//
//  main.m
//  dictonary
//
//  Created by henryyu on 10-11-04.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SomeClass.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	SomeClass *cls = [[SomeClass alloc] init];
	 
	 [cls loopThrough];
	 [cls booksSample];
	 [cls audTest];
	 [cls sortingTest];
	 [cls readWritePlist];
	 
	[cls release];
    [pool release];
    return 0;
}
