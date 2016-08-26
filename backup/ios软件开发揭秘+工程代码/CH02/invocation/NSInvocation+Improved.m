//
//  NSInvocation+Improved.m
//  invocation
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdarg.h>
#import "NSInvocation+Improved.h"

@implementation NSInvocation (Improved)

+ (NSInvocation*)invocationWithTarget:(id)_target andSelector:(SEL)_selector
{
	NSMethodSignature* methodSig = [_target methodSignatureForSelector:_selector];
	NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSig];
	
	[invocation setTarget:_target];
	[invocation setSelector:_selector];
	
	return invocation;
}

// Remember to take the address of each argument rather than passing it as a literal!
+ (NSInvocation*)invocationWithTarget:(id)_target andSelector:(SEL)_selector andArguments:(void*)_addressOfFirstArgument, ...
{
	NSMethodSignature* methodSig = [_target methodSignatureForSelector:_selector];
	NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSig];
	
	[invocation setTarget:_target];
	[invocation setSelector:_selector];

	unsigned int numArgs = [methodSig numberOfArguments];

	if (2 < numArgs)
	{
		va_list varargs;
		va_start(varargs, _addressOfFirstArgument);
		[invocation setArgument:_addressOfFirstArgument atIndex:2];

		for (int argIdx=3; argIdx<numArgs; ++argIdx)
		{
			// We could do type-checking here someday
			void* argp = va_arg(varargs, void *);
			[invocation setArgument:argp atIndex:argIdx];
		}
		
		va_end(varargs);
	}
	
	return invocation;
}

- (void)invokeOnMainThreadWaitUntilDone:(BOOL)wait
{
	[self performSelectorOnMainThread:@selector(invoke)
						   withObject:nil
						waitUntilDone:wait];
}

@end
