//
//  Category.h
//  Zoo
//
//  Created by Henry Yu on 10-11-09.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Animal;

@interface Category :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber *uid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet* animals;

@end


@interface Category (CoreDataGeneratedAccessors)
- (void)addAnimalsObject:(Animal *)value;
- (void)removeAnimalsObject:(Animal *)value;
- (void)addAnimals:(NSSet *)value;
- (void)removeAnimals:(NSSet *)value;

@end

