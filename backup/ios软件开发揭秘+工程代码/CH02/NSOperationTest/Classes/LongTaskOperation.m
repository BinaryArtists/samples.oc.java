//
//  LongTaskOperation.m
//  NSOperationTest
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "LongTaskOperation.h"


@implementation LongTaskOperation
@synthesize taskDelegate;


-(id) initWithPath:(NSString*)aPath
{
	if( (self = [super init]) )
	{
		iImageFilePath	= [aPath retain];
	}
	return self;
}

-(void) dealloc
{
	[iImageFilePath release];
	[super dealloc];
}

-(void) main
{
	if( !self.isCancelled )
	{
		NSAutoreleasePool	*pool	= [[NSAutoreleasePool alloc] init];
		
		UIImage	*img	= [[UIImage alloc] initWithContentsOfFile:iImageFilePath];
		// get the image		
		if( img ){			
		}
		
		[pool drain];
		
		if( !self.isCancelled && taskDelegate )
			[taskDelegate longTaskOperationFinished:self];
	}
}


@end
