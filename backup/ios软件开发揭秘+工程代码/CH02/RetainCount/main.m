//
//  main.m
//  retain
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SomeClass.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];    
	// create two objects my MyClass.
    SomeClass *object = [[SomeClass alloc] init];	
    
    NSLog(@"1,object retain count is : %d",[object retainCount]); // counter is 1	
    
    [object retain]; // increment the count, now count is 2   	
    NSLog(@"2,object retain count is : %d",[object retainCount]); 	
    
    [object release]; // decrement the count, now count is 1
    NSLog(@"3,object retain count is : %d",[object retainCount]); 	
    	
	object = nil; // set to nil, now count is 0, now object will deallocate.   	
	NSLog(@"4,object retain count is : %d",[object retainCount]);
	NSLog(@"5,object: %@",object);
	
    [pool release];
	
    return 0;
}
