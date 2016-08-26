//
//  SomeClass.m
//  dictonary
//
//  Created by henryyu on 10-11-04.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SomeClass.h"


@implementation SomeClass

- (void)loopThrough{
	
	NSArray  *keys = [NSArray arrayWithObjects:@"key1", @"key2", @"key3", nil];
    NSArray *objects = [NSArray arrayWithObjects:@"How", @"are", @"you", nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	//Case 1, loop through 
	for (id key in dictionary) {		
        NSLog(@"key: %@, value: %@", key, [dictionary objectForKey:key]);		
    }
	
	//Case 2, loop through 
	NSEnumerator *enumerator;
    id key;	
	enumerator = [dictionary keyEnumerator];    
    while ((key = [enumerator nextObject])){  
        NSLog(@"%@====>%@", key, [dictionary objectForKey:key]);
    }
	
}

- (void)booksSample{
	NSMutableArray *books = [[NSMutableArray alloc] init];
	for(int i = 0; i < 5; i++){	
		NSMutableDictionary *book = [[NSMutableDictionary alloc] init];	
		[book setValue: [NSString stringWithFormat:@"bookName%d",i] forKey: @"Name"];
		[book setValue: [NSString stringWithFormat:@"bookAuthor%d",i] forKey: @"Author"];
		[book setValue: [NSString stringWithFormat:@"Publisher%d",i] forKey: @"Publisher"];
		[book setValue: [NSNumber numberWithInt:i+20] forKey: @"Price"];		
		[books addObject:book];
		[book release];
	}
	
	//dump the books
	NSDictionary *book;
	for(book in books){
		NSString *bookName = [book objectForKey:@"Name"];
	    NSLog(@"bookName:%@",bookName);
		NSLog(@"book:%@",book);
	}
}

- (void)audTest{
	NSMutableDictionary *dict = 
	    [NSMutableDictionary dictionaryWithCapacity:3];
	[dict setObject:@"yellow" forKey:@"Dog"];
	[dict setObject:@"black" forKey:@"Cat"];
	[dict setObject:@"white" forKey:@"Pig"];	
	NSLog(@"animals:%@",dict);
	
	//Case 1, update element
	[dict setObject:@"yellow" forKey:@"Dog"];
	NSLog(@"animals:%@",dict);
	
	//Case 2, remove element
	[dict removeObjectForKey:@"Cat"];
	NSLog(@"animals:%@",dict);
	
	//Case 3, remove all element
	[dict removeAllObjects];
	NSLog(@"animals:%@",dict);
	
}

- (void)sortingTest{
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: 
			  [NSNumber numberWithInt:63], @"Mathematics",
			  [NSNumber numberWithInt:72], @"English",
			  [NSNumber numberWithInt:55], @"History",
			  [NSNumber numberWithInt:49], @"Geography", nil];
	
	NSLog(@"dict count:%d",[dict count]);
	NSLog(@"dict allKeys:%@",[dict allKeys]);
	NSLog(@"dict allValues:%@",[dict allValues]);
	
	//NSDictionary Comparing
	NSMutableDictionary *dictionary = 
	[NSMutableDictionary dictionaryWithCapacity:0];
	if([dict isEqualToDictionary:dictionary]){
		NSLog(@"the dictionaries are same");
	}else{
		NSLog(@"the dictionaries are not same");
	}
	
	//keysSortedByValueUsingSelector return array is wrong!!
	NSArray *sortedKeysArray = 
	  [dict keysSortedByValueUsingSelector:@selector(compare:)];
	//sortedKeysArray contains:(Geography,History,Mathematics, English)
	NSLog(@"sortedKeysArray:%@",sortedKeysArray);
	
	NSArray *keys = [dict allKeys];
	NSArray *sortedArray = 
	[keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];	
	NSLog(@"sortedArray:%@",sortedArray);
	
}

- (void)readWritePlist{
	NSString *homePath = [[NSBundle mainBundle] executablePath];
	NSArray *strings = [homePath componentsSeparatedByString: @"/"];
	NSString *executableName  = [strings objectAtIndex:[strings count]-1];	
	NSString *baseDirectory = [homePath substringToIndex:
							   [homePath length]-[executableName length]-1];	
	
	NSString *filePath = [NSString stringWithFormat:@"%@/data.plist",baseDirectory];
    NSLog(@"filePath: %@",filePath);
	//NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	NSMutableDictionary *dataDict = 
	[[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
	NSLog(@"dataDict: %@",dataDict);
	//change the value
	[dataDict setObject:@"YES" forKey:@"Trial"];
	//write back to file
	[dataDict writeToFile:filePath atomically:NO];
	[dataDict release];	
}

@end
