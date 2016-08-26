//
//  ComplexClass.h
//  array
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComplexClass : NSObject {	
}

+ (void)simpleSorting;
- (void)sortingPersonWithProperty:(NSString *)field;
- (void)customizeSortingTest;

- (void)filterPersonWithPredicate:(NSPredicate *)fliterText;
- (void)removePersonWithLastName:(NSString *)fliterText;
- (NSArray *)filterPersonWithLastName:(NSString *)fliterText;

- (void)mapOperation;
- (void)printingPersonArray:(NSArray *)array;

@end
