//
//  SomeClass.m
//  property
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SomeClass.h"


@implementation SomeClass
@synthesize reloadFiles,myCurrentPage,hashCode,directionArray,dictDetail;

- (id)init{
    if((self = [super init])){
        // init all properties
		reloadFiles = FALSE;
		myCurrentPage = 1;
		hashCode = @"";  
		directionArray = nil;
		dictDetail = nil;
    }
    return self;
}

- (void)dealloc{
    // cleanup all properties, otherwise, 
	// the last object assigned will be leaked
	if(directionArray != nil)
		[directionArray release];	
	if(dictDetail != nil)
		[dictDetail release];
    [super dealloc];	
}

- (void)printProperties{
	NSLog(@"reloadFiles:%d",self.reloadFiles);
	NSLog(@"myCurrentPage:%d",self.myCurrentPage);
	NSLog(@"hashCode:%@",self.hashCode);
	NSLog(@"directionArray:%@",self.directionArray);
	NSLog(@"dictDetail:%@",self.dictDetail);
}

@end
