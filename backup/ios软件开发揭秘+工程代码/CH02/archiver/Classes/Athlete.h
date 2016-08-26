//
//  Athlete.h
//  archiver
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ScoreCard;
@interface Athlete : NSObject <NSCoding> {	
	NSString *name;
	NSString *bio;
	NSString *phoneNumber;
	ScoreCard *scoreCard;
	BOOL eligible;	
}

@property (copy) NSString *name, *bio, *phoneNumber;
@property (retain) ScoreCard *scoreCard;
@property (getter=isEligible) BOOL eligible;

- (void)print;

@end