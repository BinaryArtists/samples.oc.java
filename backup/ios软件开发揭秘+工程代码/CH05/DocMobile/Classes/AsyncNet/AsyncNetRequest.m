//
//  AsyncNetRequest.m
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "AsyncNetRequest.h"

@implementation AsyncNetRequest

@synthesize successTarget;
@synthesize successAction;
@synthesize failureTarget;
@synthesize failureAction;
@synthesize userInfo;
@synthesize active;
@synthesize data;

- (id)init
{
    if (self = [super init])
    {
        data = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [data release];
    [super dealloc];
}

@end
