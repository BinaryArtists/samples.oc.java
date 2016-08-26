//
//  main.m
//  property
//
//  Created by Henry Yu on 10-11-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SomeClass.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    //case 1
	SomeClass *cls = [[SomeClass alloc] init];
	[cls printProperties];
	
	//case 2
	NSMutableArray *tempArray = [[NSMutableArray alloc]
	     initWithObjects: @"DocumentList", 
	     @"AdvancedSearch", @"Statistics", nil];
	
	NSMutableDictionary *tempDict = [NSMutableDictionary 
					 dictionaryWithObjectsAndKeys:
	               @"Sevenuc", @"name", @"www.sevenuc.com", @"url", nil];

	
	cls.reloadFiles = TRUE;
	cls.myCurrentPage = 2;
	cls.hashCode = @"1234567890";
	cls.directionArray = tempArray;
	cls.dictDetail = tempDict;
	[tempDict release];
	
	NSLog(@"tempArray->retainCount: %d", [tempArray retainCount]);
	[tempArray release];	
	NSLog(@"tempArray->retainCount: %d", [tempArray retainCount]);
	[tempArray release];
	NSLog(@"tempArray->retainCount: %d", [tempArray retainCount]);
	NSLog(@"2,-------------------------------------------------------");
	[cls printProperties];
		
	//case 3
	[tempArray addObject:@"DocumentDetail"];
	[tempDict setValue: @"Chengdu" forKey: @"address"];
	NSLog(@"3,-------------------------------------------------------");
	[cls printProperties];
		

	//case 4 
	NSMutableArray *tempArray2 = [[NSMutableArray alloc]
					 initWithObjects: @"Dog", @"Cat", @"Pig", nil];	
	NSLog(@"4,-------------------------------------------------------");
	//[cls.directionArray release];  //don't do this	
	cls.directionArray = tempArray2;
	NSLog(@"tempArray2->retainCount: %d", [tempArray2 retainCount]);	
	[tempArray2 release];
	NSLog(@"tempArray2->retainCount: %d", [tempArray2 retainCount]);
	NSLog(@"directionArray:%@",cls.directionArray);		
	
	//case 5
	NSMutableArray *tempArray3 = [[NSMutableArray alloc]
								  initWithObjects: @"One", @"Two", @"Tree", nil];	
	NSLog(@"5,-------------------------------------------------------");
	cls.directionArray = [tempArray3 copy];
	NSLog(@"tempArray3->retainCount: %d", [tempArray3 retainCount]);
	[tempArray3 release];
	NSLog(@"tempArray3->retainCount: %d", [tempArray3 retainCount]);
	NSLog(@"directionArray:%@",cls.directionArray);
			
	
	[cls release];	
    [pool release];
    return 0;
}



