//
//  NSInvocation+Improved.h
//  invocation
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#pragma once

@class NSInvocation;

@interface NSInvocation (Improved)

+ (NSInvocation*)invocationWithTarget:(id)_target andSelector:(SEL)_selector;

// Remember to take the address of each argument rather than passing it as a literal!
+ (NSInvocation*)invocationWithTarget:(id)_target andSelector:(SEL)_selector andArguments:(void*)_addressOfFirstArgument, ...;

//Perform invoke on the main thread, optionally wait until done.
//You should only read the return value if you have waited until the invocation is done.
- (void)invokeOnMainThreadWaitUntilDone:(BOOL)wait;

@end
