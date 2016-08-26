//
//  main.m
//  PrivateMethods
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SomeClass.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
   	
	SomeClass *obj = [[SomeClass alloc] init];	
	// Display message (including messages from hidden methods)
	[obj msg];	
	// Call a class method
	[SomeClass classMsg];	
		
	
    [pool release];
    return 0;
}
