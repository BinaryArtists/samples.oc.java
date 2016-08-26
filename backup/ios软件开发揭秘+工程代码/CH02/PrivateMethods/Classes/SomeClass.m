//
//  SomeClass.m
//  PrivateMethods
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SomeClass.h"

// =================================
// = Interface for hidden methods =
// =================================
@interface SomeClass (hidden)

+(void) hiddenClassMethod; 
-(void) hiddenInstanceMethod; 

@end


// =====================================
// = Implementation of hidden methods =
// =====================================
@implementation SomeClass (hidden)
+(void) hiddenClassMethod {
	NSLog( @"Hidden class method." );
}

-(void) hiddenInstanceMethod {
	NSLog( @"Hidden instance method." );
}

@end


// ================================
// = Implementation for SomeClass =
// ================================
@implementation SomeClass

static void somePrivateStaticMethod (SomeClass *myClass, id anArg)
{
    NSLog( @"Hidden private static method.");
}


-(void) msg{		
	[self hiddenInstanceMethod];	
}

+(void) classMsg{
	somePrivateStaticMethod (self, nil);
	[SomeClass hiddenClassMethod]; 	
}


@end
