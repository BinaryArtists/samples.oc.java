//
//  main.m
//  JSONTest
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "JSON.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    	
	//init the url
	//NSURL *jsonURL = [NSURL URLWithString:@"http://www.sevenuc.com/download/test-json.plist"];
	//NSString *jsonData = [[NSString alloc] initWithContentsOfURL:jsonURL];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
	NSLog(@"filePath:%@",filePath);	
	NSDictionary *dataDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	NSString *jsonData = [dataDict objectForKey:@"JSONSample"];
	
	if (jsonData == nil) {
		NSLog(@"The webservice you are accessing is down.");				
	}else {
		NSLog(@"json data:%@",jsonData);
		// converting the json data into an array
		NSArray *jsonArray = [jsonData JSONValue];
		NSLog(@"jsonArray:%@",jsonArray);		
	}
	
	// releasing the vars now
	//[jsonURL release];
	[jsonData release];	
	
    [pool release];
    return 0;
}
