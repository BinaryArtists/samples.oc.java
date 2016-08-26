//
//  main.m
//  set
//
//  Created by henryyu on 10-11-04.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SetTest.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	SetTest *obj = [[SetTest alloc] init];
	[obj commonOperation];
	[obj uniqueOperation];
	[obj safeDelete];
	
	[obj release];	
    [pool release];
    return 0;
}
