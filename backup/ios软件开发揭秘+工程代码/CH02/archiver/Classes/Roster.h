//
//  Roster.h
//  archiver
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Athlete;
@interface Roster : NSObject <NSCoding> {	
	NSMutableArray *athletes;
	int rank;	
}

@property (retain) NSMutableArray *athletes;
@property int rank;

- (void)create;
- (void)print;
- (void)addAthlete:(Athlete *)athlete;

@end
