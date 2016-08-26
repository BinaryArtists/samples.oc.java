//
//  Person.h
//  array
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
	NSString *firstName;
	NSString *lastName;
	NSNumber *salary;
	NSDate   *birthDate;
}

@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSNumber *salary;
@property (nonatomic,retain) NSDate   *birthDate;

- (void)formatName;
- (NSDate *)makeBirthDate:(NSString *)birthDay;
- (NSMutableArray *)creatTempraryList;
- (NSInteger)compareBirthDate:(Person *)another;

@end
