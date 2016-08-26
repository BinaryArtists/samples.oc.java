//
//  WebService.h
//
//  Created by Henry Yu on 09-09-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleXMLParser.h"

@interface WebDocWebService : NSObject {
    id delegate;
	id timer;
	id timer2;
	NSInteger page;
	NSInteger team;
	NSString *category;
	NSString *recordHead;
	NSMutableData *webData;
	NSXMLParser *xmlParser;	
	SimpleXMLParser* thisParser;
	NSNumber *totalFileSize;
	UIProgressView *progressView;
	UIAlertView *progressAlert;
	NSString *currentFileName;
	NSString *serviceURL;
	NSString *actionURL;
	
}

@property (retain) id delegate;
@property(nonatomic, retain) NSString *serviceURL;
@property(nonatomic, retain) NSString *actionURL;
@property(nonatomic, retain) NSNumber *totalFileSize;
@property(nonatomic, retain) UIProgressView *progressView;
@property(nonatomic, retain) UIAlertView *progressAlert;
@property(nonatomic, retain) NSString *recordHead;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property(nonatomic, retain) NSString *currentFileName;

+ (WebDocWebService *)instance;

-(void)setDelegate:(id)val;
-(id)delegate;
-(NSInteger) getRecordCount;
-(NSDictionary*) getRecordAtIndex:(NSInteger)idx;
-(NSMutableArray*) getRecordLists;

//Web Service functions.
-(void)wsInit;
-(void)wsInit_OpenSSL;
-(void)wsListDomains:(NSString *)hashCode;
-(void)wsUserLogin:(NSString *)hashCode userName:(NSString *)name  passWord:(NSString *)pass domainName:(NSString *)domain;
-(void)wsListMyDocuments:(NSString *)hashCode PageRowSize:(NSInteger)rowsize CurrentPage:(NSInteger)page;
-(void)wsListMyDocumentsByDepartment:(NSString *)hashCode PageRowSize:(NSInteger)rowsize  CurrentPage:(NSInteger)page TeamID:(NSInteger)team;
-(void)wsGetDocFile:(NSString *)hashCode DocumentID:(NSString *)document FileName:(NSString *)filename Extension:(NSString *)extension IsAnexo:(BOOL)isAnexo;
-(void)wsGetDocumentFile:(NSString *)hashCode DocumentID:(NSString *)document;
-(void)wsGetAttachmentFile:(NSString *)hashCode AttachmentID:(NSString *)attachment;
-(void)wsUpLoadFile:(NSString *)data;
-(void)wsUpLoadAttachment:(NSString *)data;

-(void)wsGetDocumentDataResumed:(NSString *)hashCode DocumentID:(NSString *)document;
-(void)wsListDocumentAttachments:(NSString *)hashCode DocumentID:(NSString *)document;
-(void)wsListFileHistory:(NSString *)hashCode DocumentID:(NSString *)document;
-(void)wsDoWorkFlow:(NSString *)hashCode DocumentID:(NSString *)document StateTo:(NSString *)state TeamTo:(NSString *)team UserTo:(NSString *)team Comment:(NSString *)comment;

-(void)wsListIndicators:(NSString *)hashCode;
-(void)wsGetIndicatorDetails:(NSString *)hashCode Indicator:(NSString *)indicatorId;
-(void)wsGetIndicatorDetailsImage:(NSString *)hashCode Indicator:(NSString *)indicatorId;
-(void)wsListWorkflowStates:(NSString *)hashCode;
-(void)wsListWorkflowStatesTo:(NSString *)hashCode DocumentID:(NSString *)document;

-(void)wsTotalMyDocuments:(NSString *)hashCode;
-(void)wsTotalMyTeamDocuments:(NSString *)hashCode TeamId:(NSString *)team;
	
-(void)wsListMyTeams:(NSString *)hashCode;
-(void)wsListMyDocumentTeams:(NSString *)hashCode StateTo:(NSString *)state Group:(NSString *)group;
-(void)wsListDirections:(NSString *)hashCode;
-(void)wsListWorkflowUsers:(NSString *)hashCode StateTo:(NSString *)state Team:(NSString *)team;
-(void)wsListDocumentTypes:(NSString *)hashCode DocumentID:(NSString *)document;
//-(void)wsAdvancedSearch:(NSString *)code State:(NSString *)state Direction:(NSString *)direction DocumentType:(NSString *)type Entry:(NSString *)entry;
-(void)wsAdvancedSearch:(NSString *)code PageRowSize:(NSInteger)rowsize  CurrentPage:(NSInteger)page DocumentCode:(NSString *)docment 
		  WorkflowState:(NSString *)state DocumentType:(NSString *)type Direction:(NSString *)direction Entity:(NSString *)entity;
//helper functions.
-(void)writeToLocalFile;
- (void)messageBox:(NSString*)message Error:(NSError*)error;
-(void)setCurrentFileName:(NSString *)filename;
-(void)doWebService:(NSString *)body sSoapXML:(NSString *)url sSOAPAction:(NSString *)action;
-(void)createProgressionAlertWithMessage:(NSString *)message withActivity:(BOOL)activity;
- (void)doLocalResponse:(NSString *)localStr;
- (void)asyncRequestSucceeded:(NSData *)data userInfo:(NSDictionary *)userInfo;
@end

//Web Service delegate methods.
@interface NSObject (WebDocWebServiceDelegateMethods)

- (void)didOperationCompleted:(NSDictionary *)dict;
- (void)didOperationError:(NSError*)error;
- (void)asyncRequestFailed:(NSError *)error userInfo:(NSDictionary *)userInfo;

@end

