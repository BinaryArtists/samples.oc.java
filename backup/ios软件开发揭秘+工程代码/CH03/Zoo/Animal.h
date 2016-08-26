//
//  Animal.h
//  Zoo
//
//  Created by Henry Yu on 10-11-09.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Animal :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSData *image;
@property (nonatomic, retain) NSNumber *cid;
@property (nonatomic, retain) NSManagedObject *category;

@end



