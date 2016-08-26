//
//  SomeClass.m
//  invocation
//
//  Created by Henry Yu on 10-11-05.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SomeClass.h"
#import "NSInvocation+Improved.h"

@implementation SomeClass

- (void)fireTimer:(NSDictionary *)user andDate:(NSDate *)startTime{
	[NSThread sleepForTimeInterval:2];
	NSTimeInterval timeDiff = -1*[startTime timeIntervalSinceNow];
	NSString *timeStr = [NSString stringWithFormat:@"%.2f", timeDiff];
	NSLog(@"fireTime:%@", timeStr);
}

- (void)commonOperation{
	NSDate *date = [NSDate date];
	NSDictionary *user = 
	   [NSDictionary dictionaryWithObjectsAndKeys:@"bar",@"foo",nil];
	SEL method = @selector(fireTimer:andDate:);
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:method];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:method];
    [invocation setArgument:&user atIndex:2];
    [invocation setArgument:&date atIndex:3];
    //[NSTimer scheduledTimerWithTimeInterval:0.1 invocation:invocation repeats:YES];
	[invocation invoke];	
}

- (void)improvedOperation{
	//Case 1, Create NSInvocation with no parameter.
	//SEL selector = @selector(fireTimer:andDate:);
	//NSInvocation *invocation = 
	//   [NSInvocation invocationWithTarget:self andSelector:selector];
	
	//Case 2, Create NSInvocation with two parameters.
	NSDate *date = [NSDate date];
	NSDictionary *user = 
	 [NSDictionary dictionaryWithObjectsAndKeys:@"bar",@"foo",nil];
	NSInvocation *invocation = 
	     [NSInvocation invocationWithTarget:self 
					andSelector:@selector(fireTimer:andDate:)
					andArguments:&user, &date];
	[invocation invoke];
	
}


@end
