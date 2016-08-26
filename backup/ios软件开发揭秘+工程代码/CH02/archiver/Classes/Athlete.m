//
//  Athlete.m
//  archiver
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "Athlete.h"
#import "ScoreCard.h"

@implementation Athlete

@synthesize name, bio, phoneNumber, scoreCard, eligible;

- (id)init {	
	if (self = [super init]) {		
		name = [[NSString alloc] init];
		bio = [[NSString alloc] init];
		phoneNumber = [[NSString alloc] init];
		scoreCard = [[ScoreCard alloc] init];
		eligible = YES;		
	}	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {	
	if (self = [super init]) {		
		name = [[aDecoder decodeObjectForKey:@"name"] retain];
		bio = [[aDecoder decodeObjectForKey:@"bio"] retain];
		phoneNumber = [[aDecoder decodeObjectForKey:@"phoneNumber"] retain];
		scoreCard = [[aDecoder decodeObjectForKey:@"scoreCard"] retain];
		eligible = [aDecoder decodeBoolForKey:@"eligible"];		
	}	
	return self;	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {	
	[aCoder encodeObject:name forKey:@"name"];
	[aCoder encodeObject:bio forKey:@"bio"];
	[aCoder encodeObject:phoneNumber forKey:@"phoneNumber"];
	[aCoder encodeObject:scoreCard forKey:@"scoreCard"];
	[aCoder encodeBool:eligible forKey:@"eligible"];	
}

- (void)print {	
	NSLog(@"Name: %@\nBio: %@\nTel: %@\n\nBest Time: %@\n\nAll Times:", 
		  name, bio, phoneNumber, [scoreCard bestTime]);
	for (NSString *time in [scoreCard allTimes])
		NSLog(@"%@", time);	
}

- (void)dealloc {	
	[name release];
	[bio release];
	[phoneNumber release];
	[scoreCard release];
	[super dealloc];	
}

@end
