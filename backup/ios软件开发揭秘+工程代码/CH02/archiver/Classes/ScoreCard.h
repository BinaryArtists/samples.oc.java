//
//  ScoreCard.h
//  archiver
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreCard : NSObject <NSCoding> {	
	NSString *bestTime;
	NSMutableArray *allTimes;	
}

@property (copy) NSString *bestTime;
@property (copy) NSMutableArray *allTimes;

// other methods not relevant to this tutorial go here

@end
