//
//  ScoreCard.m
//  archiver
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "ScoreCard.h"

@implementation ScoreCard

@synthesize bestTime, allTimes;

- (id)init {	
	if (self = [super init]) {		
		bestTime = [[NSString alloc] init];
		allTimes = [[NSMutableArray alloc] init];		
	}	
	return self;	
}

- (id)initWithCoder:(NSCoder *)aDecoder {	
	if (self = [super init]) {		
		bestTime = [[aDecoder decodeObjectForKey:@"bestTime"] retain];
		allTimes = [[aDecoder decodeObjectForKey:@"allTimes"] retain];		
	}	
	return self;	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {	
	[aCoder encodeObject:bestTime forKey:@"bestTime"];
	[aCoder encodeObject:allTimes forKey:@"allTimes"];	
}

- (void)dealloc {	
	[bestTime release];
	[allTimes release];
	[super dealloc];	
}

@end
