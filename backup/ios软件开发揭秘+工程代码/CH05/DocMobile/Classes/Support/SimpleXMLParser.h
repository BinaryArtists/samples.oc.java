//
//  SimpleXMLParser.h
//  
//  Created by Henry Yu on 09-09-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import <Foundation/Foundation.h>


@interface SimpleXMLParser : NSObject{
	NSString *currentPropertyName;
	NSMutableString *currentData;
	BOOL contentError;
	NSString *faultName;
	NSString *faultName2;
	NSMutableData *webData;
	NSMutableArray *theMainStack;
	NSMutableArray *currentDataStack;
	
	NSXMLParser *parser;
	NSString *recordHead;
	NSInteger sectionCount;
	BOOL beginRecord;
	NSMutableString *currentCharacters;
	NSMutableDictionary *parsedResponseDictionary;
	NSString *parseElementPath;
}

- (id)init;
- (void)initData:(NSMutableData *)data;
- (void)parse:(NSString*)head;
- (BOOL)isContentFault;
- (NSInteger)getRecordCount;
- (NSDictionary*)getRecordAtIndex:(NSInteger)idx;
- (NSMutableArray*)getRecordLists;

@end
