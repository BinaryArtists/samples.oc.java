//
//  SetTest.m
//  set
//
//  Created by henryyu on 10-11-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SetTest.h"


@implementation SetTest

- (void)commonOperation{
	NSMutableSet *set = [[NSMutableSet alloc] init];
	for(int i= 0; i< 10; i++){
	    [set addObject:[NSNumber numberWithInt:i]];
	}
	NSLog( @"%@", set);
	
	//Try to add an element that already exists in set
	[set addObject:[NSNumber numberWithInt:5]];
	[set release];		
}

- (void)uniqueOperation{
	NSArray *array = [NSArray arrayWithObjects:@"Henry",
		  @"Jones", @"Susan", @"Smith", @"Patty",
		@"Jones", @"Johnson",@"Smith", nil];
	NSLog( @"%@", array);
	
	NSSet *uniqueElements = [NSSet setWithArray:array];
	// iterate over the unique items
	for(id element in uniqueElements) {
		// do something
		NSLog( @"%@", element);
	}	
}

- (void)safeDelete{
	NSMutableSet *set = [[NSMutableSet alloc] initWithObjects:
		 @"Henry",@"Jones",@"Susan",@"Smith",@"Patty",@"Johnson",nil];
	NSMutableSet *remove = [[NSMutableSet alloc] init];
	for (NSString* unit in set ) {
		if ( [unit hasPrefix:@"S"] ) {
			[remove addObject:unit];			
		}
	}
	NSLog( @"%@", set);
	[set minusSet:remove];
	NSLog( @"%@", set);
	[remove release];
	[set release];
}


@end
