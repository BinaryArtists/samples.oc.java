//
//  main.m
//  array
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SimpleClass.h"
#import "ComplexClass.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    	
	SimpleClass *simple = [[SimpleClass alloc] init];
	[simple commonOperation];
	[simple commonOperation2];
	[simple sortOperation];			
	[simple mapOperation];
	[simple readWritePlist:NO];
	[simple release];

	
	[ComplexClass simpleSorting];	
	ComplexClass *filter = [[ComplexClass alloc] init];
	
	[filter sortingPersonWithProperty:@"lastName"];
	[filter sortingPersonWithProperty:@"salary"];
	[filter sortingPersonWithProperty:@"birthDate"];
	
	[filter customizeSortingTest];
	
	[filter filterPersonWithPredicate:nil];
	[filter removePersonWithLastName:@"Riaz"];
	[filter filterPersonWithLastName:@"Riaz"];
	[filter mapOperation];
	
	[filter release];

    [pool release];	
    return 0;
}
			
				
