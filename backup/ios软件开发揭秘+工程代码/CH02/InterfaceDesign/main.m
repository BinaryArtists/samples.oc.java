//
//  main.m
//  ShadowClass
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	MyClass *c = [[[MyClass alloc] init] autorelease];
	[c doSomething:@"some thing"];
		
    [pool release];
    return 0;	
	
}



