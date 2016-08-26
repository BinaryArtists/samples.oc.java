//
//  RecordCache.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "Document.h"
#import "Indicator.h"

@interface RecordCache: NSObject {
  NSPersistentStoreCoordinator  *persistentStoreCoordinator;
  NSManagedObjectModel          *managedObjectModel;
  NSManagedObjectContext        *managedObjectContext;	    
  
}

@property(nonatomic, readonly, retain) NSPersistentStoreCoordinator  *persistentStoreCoordinator;
@property(nonatomic, readonly, retain) NSManagedObjectModel          *managedObjectModel;
@property(nonatomic, readonly, retain) NSManagedObjectContext        *managedObjectContext;

//+(RecordCache *)instance;
-(id)init;
-(BOOL)save;
-(void)onApplicationTerminate;
-(NSPersistentStoreCoordinator *)resetPersistentStore;
-(NSNumber *)nextDocumentIdentifier;
-(BOOL)addDocument:(NSDictionary *)dict Category:(NSString*)category;
-(BOOL)addAttachment:(NSDictionary *)dict;
-(BOOL)addHistory:(NSDictionary *)dict;
-(BOOL)addIndicator:(NSDictionary *)dict;
-(NSArray*)allDocuments:(int)page Team:(int)team Category:(NSString*)category;
-(NSArray*)allAttachment:(NSString*)documentId;
-(NSArray*)allHistories:(NSString*)documentId;
-(NSArray*)allIndicator;
-(Document*)documentById:(NSString*)documentId;
-(Indicator*)indicatorById:(NSString*)indicatorId;

@end

