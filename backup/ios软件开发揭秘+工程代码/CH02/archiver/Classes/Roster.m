//
//  Roster.m
//  archiver
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "Roster.h"
#import "Athlete.h"
#import "ScoreCard.h"

@implementation Roster

@synthesize rank, athletes;

static NSString *names [] = { @"John Doe",
	@"Jane Doe", @"Shaun White", @"Jeff Beck",
	@"Eric Clapton", @"Angus Young", @"Flavius Josephus" };

- (void)create{	
	NSMutableArray *scoresArray = [NSMutableArray arrayWithObjects:
				   @"15:09:34", @"17:54:01", @"19:56:08", nil];
	
	//Roster *roster = [[Roster alloc] init];
	for (int i = 0; i < 7; ++i) {		
		Athlete *athlete = [[Athlete alloc] init];
		[athlete setName:names[i]];
		[athlete setBio:@"I'm a boss"];
		[athlete setPhoneNumber:@"867-5309"];
		[athlete.scoreCard setBestTime:@"12:30:34"];
		[athlete.scoreCard setAllTimes:scoresArray];		
		[self addAthlete:athlete];		
	}	
	//return [roster autorelease];	
}


- (id)init {	
	if (self = [super init]) {		
		rank = 0;
		athletes = [[NSMutableArray alloc] init];		
	}	
	return self;	
}

- (id)initWithCoder:(NSCoder *)aDecoder {	
	if (self = [super init]) {		
		athletes = [[aDecoder decodeObjectForKey:@"athletes"] retain];
		rank = [aDecoder decodeIntForKey:@"rank"];		
	}	
	return self;	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {	
	[aCoder encodeObject:athletes forKey:@"athletes"];
	[aCoder encodeInt:rank forKey:@"rank"];	
}

- (void)addAthlete:(Athlete *)athlete {	
	[athletes addObject:athlete];	
}

- (void)print {	
	NSLog(@"Roster info:\nRank: %d", rank);
	for (Athlete *athlete in athletes)
		NSLog(@"%@", [athlete name]);	
}

- (void)dealloc {	
	[athletes release];
	[super dealloc];
}

@end

