//
//  MyClass.m
//  ShadowClass
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "MyClass.h"

// MyClass.m
@interface MyClassImpl : MyClass {
	// Your private and hidden instance variables here
	NSString *privateData;
}
@end

// 
@implementation MyClass
+ (id) allocWithZone:(NSZone *)zone
{
	return NSAllocateObject([MyClassImpl class], 0, zone);
}

// Your methods here
- (void)doSomething:(NSString *)str{
	// This method is considered as pure virtual and cannot be invoked
	[self doesNotRecognizeSelector: _cmd];          
}

@end

@implementation MyClassImpl
- (void)doSomething:(NSString *)str{
	// A real implementation of doSomething
	privateData = [str retain];
	NSLog(@"%@",privateData);	
}

- (void)dealloc {
    [privateData release];    
    [super dealloc];
}


@end




