//
//  SimpleXMLParser.m
//
//  Created by Henry Yu on 09-09-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import "SimpleXMLParser.h"

@implementation SimpleXMLParser

- (id)init
{
    if((self = [super init]))
	{
       	parser = nil;
		theMainStack = nil;
		currentDataStack = nil;
		webData = nil;		
    }
    return self;
}

- (id)initWithURL:(NSURL *)url{	
	parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	theMainStack = [[NSMutableArray alloc] init];
	currentDataStack = [[NSMutableArray alloc] init];
	faultName = @"faultcode"; 
    faultName2 =  @"soap:Fault";
	
	return [super init];
}

- (void)initData:(NSMutableData *)data{	
	if(parser != nil){
		[parser release];
		parser = nil;
	}
	if(theMainStack != nil){
		[theMainStack release];
		theMainStack = nil;
	}
	if(currentDataStack != nil){
		[currentDataStack release];
		currentDataStack = nil;
	}
	if(webData != nil){
		webData = nil;
	}
	
	webData = data;
	theMainStack = [[NSMutableArray alloc] init];
	currentDataStack = [[NSMutableArray alloc] init];
	//<soap:Fault><faultcode>
	faultName = @"faultcode"; 
    faultName2 =  @"soap:Fault"; 
	parser = [[NSXMLParser alloc] initWithData: webData];
		
	//return [super init];
	
}

- (void) parse:(NSString*)head{
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities: YES];
	contentError = FALSE;
	recordHead = head;
	[parser parse];	
}

- (BOOL)isContentFault{
	return contentError;
}

- (NSMutableArray*) getRecordLists{
	return theMainStack;
}

- (NSInteger) getRecordCount{
	return [theMainStack count];
}

- (NSDictionary*) getRecordAtIndex:(NSInteger)idx{	

	return [[theMainStack objectAtIndex:idx] objectForKey:recordHead];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	sectionCount = 0;
	beginRecord = NO;
	
	[parsedResponseDictionary release];
	parsedResponseDictionary = [[NSMutableDictionary alloc] init];
	parseElementPath = @"";
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {	
		
	if ([elementName isEqualToString:recordHead]){
		sectionCount++;
		beginRecord = YES;
	}	
	if([elementName isEqualToString:faultName]
	   ||[elementName isEqualToString:faultName2]){
		contentError = TRUE;		
		return;
	}	
	if(!beginRecord) return;
	
	NSMutableDictionary *newElement = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *parent;
	if ([parseElementPath length] == 0) {
		parent = parsedResponseDictionary;
	} else {
		parent = [parsedResponseDictionary valueForKeyPath:parseElementPath];
		// note valueForKeyPath: sted valueForKey:
	}	
	[parent setValue:newElement forKey:elementName];
	[newElement release];
	NSString *newParseElementPath = nil;
	if ([parseElementPath length] > 0) {
		newParseElementPath = [[NSString alloc] initWithFormat: @"%@.%@",
							   parseElementPath, elementName];
	} else {
		newParseElementPath = [elementName copy];
	}
	parseElementPath = newParseElementPath;	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
	
	//if([elementName isEqualToString:faultName]||!beginRecord)
	//	return;
	
	//SERVER faultName2:soap:Fault, elementName:soap:Fault	
	if([elementName isEqualToString:faultName]
	   ||[elementName isEqualToString:faultName2]){		
		contentError = TRUE;
		return;
	}
	if(!beginRecord) return;
	if (currentCharacters) {		
		NSMutableDictionary *elementDict =
		[parsedResponseDictionary valueForKeyPath:parseElementPath];
		[elementDict setValue: currentCharacters forKey: @"value"];
		currentCharacters = nil;		
	}
	NSRange parentPathRange;
	parentPathRange.location = 0;
	NSRange dotRange = [parseElementPath
						rangeOfString:@"." options:NSBackwardsSearch];
	NSString *parentParseElementPath = nil;
	if (dotRange.location != NSNotFound) {
		parentPathRange.length = dotRange.location;
		parentParseElementPath =
		[parseElementPath substringWithRange:parentPathRange];
	} else {
		parentParseElementPath = @"";
	}
	parseElementPath = parentParseElementPath;
		
	if ([elementName isEqualToString:recordHead]){
		if(sectionCount > 1){ 
			sectionCount--;
		}else{		    
		    [theMainStack addObject:parsedResponseDictionary];
		    sectionCount = 0;
		    parsedResponseDictionary = [[NSMutableDictionary alloc] init];
		    parseElementPath = @"";
		    beginRecord = NO;
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!currentCharacters) {
		currentCharacters = [[NSMutableString alloc]
							 initWithCapacity:[string length]];
	}
	[currentCharacters appendString:string];
}

- (void)dealloc{
	if(parser) [parser release];
	if(theMainStack) [theMainStack release];
	if(currentDataStack) [currentDataStack release];
	if(webData) [webData release];		
    [super dealloc];
	
}


@end
