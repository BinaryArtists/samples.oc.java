//
//  Indicator.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//
#import <CoreData/CoreData.h>

@interface Indicator : NSManagedObject {
}

@property (nonatomic, retain) NSString *indicatorId;
@property (nonatomic, retain) NSString *indicatorIcon;
@property (nonatomic, retain) NSString *indicatorName;
@property (nonatomic, retain) NSString *indicatorValue;
@property (nonatomic, retain) NSString *indicatorImage;
@property (nonatomic, retain) NSString *createDate;

@end


