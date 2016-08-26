//
//  RecordCache.m
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//
#import "RecordCache.h"
#import "Constants.h"

@implementation RecordCache


+ (RecordCache *)instance
{
    static RecordCache *x = nil;
    if (x == nil)
        x = [[RecordCache alloc] init];
    return x;
}

- (id)init{
  if(self = [super init]){
      self.managedObjectContext;
	  [self resetPersistentStore];
  }
  return self;
}


- (void)onApplicationTerminate{
	NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//abort();
        } 
    }
}

- (NSNumber *)nextDocumentIdentifier {
	//NSString *nextId = @"Document01";
	NSNumber *nextId = [NSNumber numberWithInt:1];
	
	NSManagedObjectContext *ctx = self.managedObjectContext;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" 
											  inManagedObjectContext:ctx];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	NSString *predFormat = @"documentId = max(documentId)";
	NSPredicate *pred = [NSPredicate predicateWithFormat:predFormat];
	[fetchRequest setPredicate:pred];
	
	NSError *error = nil;
	NSArray *values = [ctx executeFetchRequest:fetchRequest error:&error];
	if(0 != [values count]) {
		Document *session = [values objectAtIndex:0];
		NSString *maxId = [session valueForKey:@"documentId"];
		NSString *number = [maxId stringByTrimmingCharactersInSet:
							[NSCharacterSet letterCharacterSet]];
		//NSString *name = [maxId stringByTrimmingCharactersInSet:
		//				  [NSCharacterSet decimalDigitCharacterSet]];
		NSNumberFormatter *formatter = 
		[[[NSNumberFormatter alloc] init] autorelease];
		NSNumber *value = [formatter numberFromString:number];
		//nextId = [NSString stringWithFormat:@"%@%02d", name, [value intValue] + 1];
		nextId = [NSNumber numberWithInt:[value intValue] + 1];
	}
	return nextId;
}


-(BOOL)addDocument:(NSDictionary *)dict Category:(NSString*)category{
	Document *doc = (Document *)[NSEntityDescription insertNewObjectForEntityForName:@"Document" 
						   inManagedObjectContext:self.managedObjectContext];
	
	doc.category = [dict objectForKey:@"category"];
	doc.createDate = [dict objectForKey:@"createDate"];
	
	//get next database index.
	//doc.page = [self nextDocumentIdentifier];
	doc.documentId = [dict objectForKey:@"documentId"];
	doc.documentIcon = [dict objectForKey:@"documentIcon"];
	doc.documentCode = [dict objectForKey:@"documentCode"];
	doc.documentName = [dict objectForKey:@"documentName"];
	
	//Details
	doc.documentSubject = [dict objectForKey:@"documentSubject"];
	doc.documentDirection = [dict objectForKey:@"documentDirection"];
	doc.documentType = [dict objectForKey:@"documentType"]; 
	doc.documentDate = [dict objectForKey:@"documentDate"];
	doc.documentEntry = [dict objectForKey:@"documentEntry"];
	doc.documentState= [dict objectForKey:@"documentState"];
	
	return [self save];
}

-(BOOL)addAttachment:(NSDictionary *)dict{
	DocumentAttachment *attach = (DocumentAttachment *)[NSEntityDescription insertNewObjectForEntityForName:@"Attachment" 
									  inManagedObjectContext:self.managedObjectContext];
	attach.documentId = [dict objectForKey:@"documentId"];
	attach.attachmentName = [dict objectForKey:@"attachmentName"];	
	return [self save];
}

-(BOOL)addHistory:(NSDictionary *)dict{
	DocumentHistory *history = (DocumentHistory *)[NSEntityDescription insertNewObjectForEntityForName:@"History" 
						 inManagedObjectContext:self.managedObjectContext];
	history.documentId = [dict objectForKey:@"documentId"];
	history.historyText = [dict objectForKey:@"historyText"];	
	history.historyTitle = [dict objectForKey:@"historyTitle"];		
	return [self save];
}

-(BOOL)addIndicator:(NSDictionary *)dict{
	Indicator *indicator = (Indicator *)[NSEntityDescription insertNewObjectForEntityForName:@"Indicator" 
									inManagedObjectContext:self.managedObjectContext];
	indicator.indicatorId = [dict objectForKey:@"indicatorId"];
	indicator.indicatorIcon = [dict objectForKey:@"indicatorIcon"];	
	indicator.indicatorName = [dict objectForKey:@"indicatorName"];	
	indicator.indicatorValue = [dict objectForKey:@"indicatorValue"];	
	indicator.indicatorImage = [dict objectForKey:@"indicatorImage"];	
	indicator.createDate     = [dict objectForKey:@"createDate"];			
	return [self save];	
}


-(NSArray*)allDocuments:(int)page Team:(int)team Category:(NSString*)category{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSSortDescriptor *sortDescriptors = [[NSSortDescriptor alloc] initWithKey:@"dbIndex" ascending:YES];
	//[request setSortDescriptors:sortDescriptors];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptors]];
	//NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"documentId" 
	//						ascending:YES selector:@selector(caseInsensitiveCompare:)];
	//[request setSortDescriptors:[NSArray arrayWithObject:sort]];		
	// Set the batch size to a suitable number.
	//[fetchRequest setFetchBatchSize:RECORD_PER_PAGE];		
		
    //int min = RECORD_PER_PAGE*page-RECORD_PER_PAGE;
	//int max = RECORD_PER_PAGE*page;
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	if([category isEqualToString:MyTeamDocument]){
	   NSPredicate *predicate = [NSPredicate predicateWithFormat:
			@"category = %@ AND (page == %d AND team == %d)", category, page, team];
	   [request setPredicate:predicate];
	}else{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:
								  @"category == %@ AND page == %d", category, page];
		[request setPredicate:predicate];
	}
	
	NSError *error;
	NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (!results){
		NSLog(@"Error: %@ (%@)", [error localizedDescription], [error userInfo]);
	}
	[sortDescriptors release]; 
	[request release];	
	return results;
}

-(NSArray*)allAttachment:(NSString*)documentId{
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Attachment" 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentId == %@", documentId];
	[request setPredicate:predicate];
	return [self.managedObjectContext executeFetchRequest:request error:NULL]; 
}

-(NSArray*)allHistories:(NSString*)documentId{
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"History" 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentId == %@", documentId];
	[request setPredicate:predicate];
	return [self.managedObjectContext executeFetchRequest:request error:NULL]; 
}

-(NSArray*)allIndicator{
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Indicator" 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	return [self.managedObjectContext executeFetchRequest:request error:NULL];
}

-(Document*)documentById:(NSString*)documentId{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentId == %@", documentId];
	[request setPredicate:predicate];
	NSError *error;
	NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];	
	if (!results){
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	//NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	if(results > 0)
	    return [results objectAtIndex:0];		
	return nil;	
}

-(Indicator*)indicatorById:(NSString*)indicatorId{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Indicator" 
											  inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"indicatorId == %@", indicatorId];
	[request setPredicate:predicate];
	NSError *error;
	NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
	[request release];	
	if (!results){
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	//NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	if(results > 0)
	    return [results objectAtIndex:0];		
	return nil;	
}

#pragma mark -
#pragma mark COMMON API 

-(BOOL)save{
  NSError *error;
  if ([self.managedObjectContext save:&error]) {
		return YES;
  }
  return NO;
}

- (NSManagedObjectContext *) managedObjectContext {
  if (managedObjectContext != nil) {
    return managedObjectContext;
  }
  NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
  if (coordinator) {
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return managedObjectContext;	
}

-(NSManagedObjectModel*) managedObjectModel{
  if(managedObjectModel != nil){
    return managedObjectModel;
  }
  managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
  return managedObjectModel;  
}

-(NSPersistentStoreCoordinator*) persistentStoreCoordinator{
  if (persistentStoreCoordinator != nil) {
    return persistentStoreCoordinator;
  }
  //NSURL *storeUrl = [NSURL fileURLWithPath:[NSHomeDirectory() 
  //				stringByAppendingPathComponent:@"Documents/WebDoc.sqlite"]]; 
  NSString *applicationDocumentsDirectory = 
	[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSLog(@"applicationDocumentsDirectory: %@", applicationDocumentsDirectory);
	
  NSURL *storeUrl = [NSURL fileURLWithPath: 
					   [applicationDocumentsDirectory 
						stringByAppendingPathComponent: @"WebDoc.sqlite"]];
  NSError *error;
  //NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
	//					 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
	//					 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								initWithManagedObjectModel:self.managedObjectModel];
  if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
							configuration:nil URL:storeUrl options:nil error:&error]) {
	  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	  //abort();
  } 
  
  return persistentStoreCoordinator;		
}

- (NSPersistentStoreCoordinator *)resetPersistentStore {
    NSError *error = nil;
	
    if ([persistentStoreCoordinator persistentStores] == nil)
        return [self persistentStoreCoordinator];
	
    [managedObjectContext reset];
    [managedObjectContext lock];
	
    // FIXME: dirty. If there are many stores...
    NSPersistentStore *store = [[persistentStoreCoordinator persistentStores] lastObject];
	
    if (![persistentStoreCoordinator removePersistentStore:store error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }  
	
    // Delete file
    if ([[NSFileManager defaultManager] fileExistsAtPath:store.URL.path]) {
        if (![[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
	
    // Delete the reference to non-existing store
    [persistentStoreCoordinator release];
    persistentStoreCoordinator = nil;
	
    NSPersistentStoreCoordinator *r = [self persistentStoreCoordinator];
    [managedObjectContext unlock];
	
    return r;
}

-(void)dealloc{
	[persistentStoreCoordinator release];
	[managedObjectModel release];
	[managedObjectContext release];
	[super dealloc];
}

@end
