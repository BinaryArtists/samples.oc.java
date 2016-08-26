//
//  SimpleClass.m
//  array
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) \
     ((__MIN__)+random()%((__MAX__+1)-(__MIN__)))

#import "SimpleClass.h"
#import <stdlib.h>
#import <time.h>

@implementation SimpleClass

- (void)commonOperation{
	//Here only using strings,
	//but you can any object to an NSArray or NSMutableArray
	
	//Case 1, Creating an array with strings
	NSArray *array = [NSArray arrayWithObjects:@"Henry",
			 @"Jones", @"Susan", @"Smith", @"Patty", @"Johnson", nil];
	
	//You could use NSLog to dump the array contents like so
	NSLog(@"%@", array);
	
	//Case 2, Accessing an array's contents 
	for ( NSString *employee in array ){
		NSLog( @"employee:%@", employee);
	}
	
	//Accessing an array's contents using NSEnumerator
	NSEnumerator *enumerator = [array objectEnumerator];
	id obj;	
	while ( obj = [enumerator nextObject] ) {
		NSLog( @"enumerator:%@", obj);
	}
		
	//Case 3,  Creates an NSArray from another NSArray
	NSArray *myArray = [NSArray arrayWithArray:array];
	NSLog(@"%@", myArray);
		
	//Case 4, You can also use for loop walk through the array
	for(int i = 0; i < [array count]; i++){		
		NSLog(@"%@", [array objectAtIndex:i]);
	}	
	
	//Case 5, Detect if the array contains an element
	NSString *smith = @"Smith";
	if([array containsObject:smith]){
		NSLog(@"array contains: %@", smith);
	}else{
		NSLog(@"array not contains: %@", smith);
	}
	
	//Case 6, Find the index of object in the array
	NSInteger idx = [array indexOfObject:smith];	
	// This would return 3 (since NSArrays are 0 - indexed)
	NSLog(@"Smith at:%d", idx);
	
	//Case 7, Fetch the object in the array
	NSString *element = [array objectAtIndex:0];	
	NSLog(@"element:%@", element);	
	
}

- (void)commonOperation2{
	
	//Case 1, Creating a mutable array.
	NSMutableArray *array = [[NSMutableArray alloc]
							 initWithObjects: @"Foo", @"Bar", @"FooBar", nil];
	NSLog( @"%@", array);
		
	//Case 2, Creating a mutable array with an inital capcity
	NSMutableArray *array2 = [NSMutableArray arrayWithCapacity: 3];
	//Add an object
	[array2 addObject: @"Foo"];	
	//Add another object
	[array2 addObject: @"Bar"];	
	//Insert an object at a particular index
	[array2 insertObject: @"FooBar" atIndex: 1];
	
	//Accessing an Array's contents using for
	for ( NSString *element in array2 ){
		NSLog( @"%@", element);
	}		
	
}

- (void)sortOperation{
			
	//Case 1, sorting NSString array	
	NSArray *array = [NSArray arrayWithObjects:@"Henry",
					  @"Jones", @"Susan", @"Smith", @"Patty", @"Johnson", nil];
	NSLog( @"%@", array);
	
	// This will return a sorted array
	NSArray *sortedArray = 
	  [array sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];	
	NSLog( @"%@", sortedArray);
		
	//Case 2, sorting NSNumber array
	int n = 15;
	NSMutableArray *numberArray = [[NSMutableArray alloc] initWithCapacity:n];
	//srand(time(0));
	srandom(time(NULL));
	for(int i = 0; i < n; i++)
		[numberArray addObject:[NSNumber numberWithInt:arc4random()%n]];
	NSLog( @"%@", numberArray);
	
	// This will return a sorted array 
	NSArray *numberArray2 = 
	   [numberArray sortedArrayUsingSelector:@selector(compare:)];	
	NSLog( @"%@", numberArray);	
	
	//Case 3, fetch the number object at index 3,
	int idx = 3;
	NSNumber* indicator = (NSNumber*)[numberArray2 objectAtIndex:idx];
	int selected = [indicator intValue];
	NSLog( @"selected:%d", selected);
	
	//Case 4, replace the number at the index
	NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:numberArray2];
	NSLog( @"old value:%d", [[mutableArray objectAtIndex:idx] intValue]);
	[mutableArray replaceObjectAtIndex:idx withObject:[NSNumber numberWithInt:9]];		
	NSLog( @"new value:%d", [[mutableArray objectAtIndex:idx] intValue]);
		
}

#pragma mark -
#pragma mark self defined array map operation
- (NSArray *)map:(SEL)selector Array:(NSArray *)array{
	NSMutableArray		*result;	
	result = [NSMutableArray arrayWithCapacity:[array count]];
	for (id object in array)
	{
		[result addObject:[object performSelector:selector]];
	}
	return result;
}

- (void)mapOperation{
	NSArray *array = [NSArray arrayWithObjects:@"Insert",
		  @"Update", @"Delete", @"Select", @"Alter", @"Drop", nil];
	NSLog( @"old:%@", array);
    NSArray *newArray = [self map:@selector(uppercaseString) Array:array];
	NSLog( @"new:%@", newArray);
}

- (void)readWritePlist:(BOOL)readonly{
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the
	//documents directory:
	NSString *fullFileName = [NSString stringWithFormat:@"%@/arraydata.plist", documentsDirectory];
	NSLog(@"fullFileName: %@",fullFileName);
	
	//create an array and add values to it:
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:@"One"];
	[array addObject:@"Two"];
	[array addObject:@"Three"];
	
	//this statement is what actually writes out the array
	//to the file system:
	[array writeToFile:fullFileName atomically:NO];
		
	//retrieve the array contents.
	NSMutableArray *array2 = [[NSMutableArray alloc] initWithContentsOfFile:fullFileName];
	
	NSLog(@"readWritePlist: %@",array2);
	
	[array2 release];	
	
	
}


@end
