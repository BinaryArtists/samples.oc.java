//
//  Document.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <CoreData/CoreData.h> 

@interface DocumentAttachment :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * documentId;
@property (nonatomic, retain) NSString * attachmentId;
@property (nonatomic, retain) NSString * attachmentName;
@property (nonatomic, retain) NSNumber * isAttachment;
@property (nonatomic, retain) NSString * attachmentExtension;

@end


@interface DocumentHistory : NSManagedObject {
}

@property (nonatomic, retain) NSString *documentId;
@property (nonatomic, retain) NSString *historyText;
@property (nonatomic, retain) NSString *historyTitle;
@end

@interface Document: NSManagedObject{	
}

@property (nonatomic, retain) NSNumber *page;
@property (nonatomic, retain) NSNumber *teamId;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *createDate;

@property (nonatomic, retain) NSString *documentId;
@property (nonatomic, retain) NSString *documentIcon;
@property (nonatomic, retain) NSString *documentName;

//Details
@property (nonatomic, retain) NSString *documentCode;
@property (nonatomic, retain) NSString *documentSubject;
@property (nonatomic, retain) NSString *documentDirection;
@property (nonatomic, retain) NSString *documentType;
@property (nonatomic, retain) NSString *documentDate;
@property (nonatomic, retain) NSString *documentEntry;
@property (nonatomic, retain) NSString *documentState;

@end
