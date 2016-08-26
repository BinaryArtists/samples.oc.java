//
//  DocDetailViewController.m
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "DocDetailViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "RecordCache.h"

@implementation DocDetailViewController

@synthesize webservice, managingViewController, activityIndicator;  
@synthesize codeText, subjectText, directionText, typeText, entryText, dateText, stateText;

- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"DocDetailViewController" bundle:nil]) {
        self.managingViewController = aViewController;
        self.title = @"Detail";
    }	
	
    return self;
}

- (void)setDocumentId:(NSString *)docment{
	iDocumentId = docment;
	[iDocumentId retain];	
}

- (BOOL)reloadFields{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" 
						  inManagedObjectContext:appDelegate.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentId = %@", iDocumentId];
	[request setPredicate:predicate];
	NSError *error;
	NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
	[request release];	
	if (!results){
		NSLog(@"Error: %@", [error localizedDescription]);
		return FALSE;
	}
	if([results count] > 0){
	    Document *doc = (Document *)[results objectAtIndex:0];		
		self.codeText.text =  doc.documentCode;
		self.subjectText.text =  doc.documentSubject;
		self.directionText.text = doc.documentDirection;
		self.typeText.text = doc.documentType;
		self.dateText.text = doc.documentDate;
		self.entryText.text = doc.documentEntry;
		self.stateText.text = doc.documentState;
		if([self.subjectText.text length] == 0) return FALSE;
		managingViewController.navigationItem.prompt = doc.documentSubject;
		NSLog(@"managingViewController.title:%@",managingViewController.navigationItem.prompt);
		return TRUE;
	}	
	return FALSE;
}

- (void)reloadFields2{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSDictionary *detailDict = appDelegate.dictDetail;
	if([detailDict count]){	
		
		NSLog(@"detailDict:%@",detailDict);
		
		NSDictionary *Code = [detailDict objectForKey:@"Code"];
		NSDictionary *Subject = [detailDict objectForKey:@"Subject"];
		NSDictionary *GDBook = [detailDict objectForKey:@"GDBook"];
		NSDictionary *GDBook1 = [GDBook objectForKey:@"GDBook"];//GDBook1 GDBook IDGDBookDirection
		NSDictionary *DocumentType = [detailDict objectForKey:@"DocumentType"];
		NSDictionary *GDDocumentType1 = [DocumentType objectForKey:@"GDDocumentType"]; //GDDocumentType1
		NSDictionary *RegistryDate = [detailDict objectForKey:@"RegistryDate"]; //DeliveredDate
		NSDictionary *EntityDoc = [detailDict objectForKey:@"EntityDoc"];
		NSDictionary *WorkflowState = [detailDict objectForKey:@"WorkflowState"];
		NSDictionary *WorkflowLabel = [WorkflowState objectForKey:@"WorkflowLabel"];
						
		NSString *formattedString = @"";
		NSString *tempStr = [RegistryDate objectForKey:@"value"];
		if([tempStr length] >= 10){
			NSString *strDate = [tempStr substringToIndex:10];
			/*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy:MM:dd"];	
			NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
			[dateFormatter setLocale:locale];
			NSDate *newDate = [dateFormatter dateFromString:strDate];
			formattedString = [dateFormatter stringFromDate:newDate];
			NSLog(@"strDate:%@,newDate:%@,formattedString:%@", strDate,newDate,formattedString);		
			[dateFormatter release];*/
			formattedString = strDate;
			//formattedString = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@":"];
		}else{
			formattedString = tempStr;
		}
		
		self.codeText.text =  [Code objectForKey:@"value"];
		self.subjectText.text =  [Subject objectForKey:@"value"];
		self.directionText.text = [GDBook1 objectForKey:@"value"];
		self.typeText.text = [GDDocumentType1 objectForKey:@"value"];
		self.dateText.text = formattedString; //[RegistryDate objectForKey:@"value"];
		self.entryText.text = [EntityDoc objectForKey:@"value"];
		self.stateText.text = [WorkflowLabel objectForKey:@"value"] ;
		
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];	

	codeText.userInteractionEnabled = NO;
	subjectText.userInteractionEnabled = NO;
	directionText.userInteractionEnabled = NO;
	typeText.userInteractionEnabled = NO;
	entryText.userInteractionEnabled = NO;
	dateText.userInteractionEnabled = NO;
	stateText.userInteractionEnabled = NO;	
		
}

- (void)viewWillAppear:(BOOL)animated{
	if(webservice == nil){
		webservice = [WebDocWebService instance];			
	}
	webservice.delegate = self;

	bDataFetching = FALSE;
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *hashCode = appDelegate.hashCode;
	if(appDelegate.reloadDetais){
		bDataFetching = TRUE;
		[webservice wsGetDocumentDataResumed: hashCode DocumentID:iDocumentId];
	}else{
		BOOL loaded = [self reloadFields];
		//	if(appDelegate.dictDetail == nil){	
		if(!loaded){
			bDataFetching = TRUE;
			[webservice wsGetDocumentDataResumed: hashCode DocumentID:iDocumentId];
		}else{
			/*NSDictionary *Subject = [appDelegate.dictDetail objectForKey:@"Subject"];
			 NSString *strSubject =  [Subject objectForKey:@"value"];
			 if([strSubject length] == 0){
			 bDataFetching = TRUE;
			 [webservice wsGetDocumentDataResumed: hashCode DocumentID:iDocumentId];
			 }else{
			 [self reloadFields];
			 }*/
			activityIndicator.hidden = TRUE;
		}
	}
	
	if(bDataFetching){
		activityIndicator.hidden = FALSE;
		[activityIndicator startAnimating];		
	}	
	
}

- (void)viewDidUnload {
  	codeText = nil;
	subjectText = nil;
	directionText = nil;
	typeText = nil;
	entryText = nil;
	dateText = nil;
	stateText = nil;
	
	[webservice release];
	//[self removeIndicator];
	activityIndicator = nil;
    [super viewDidUnload];
	
}


- (void)dealloc {
	[webservice release];
    self.managingViewController = nil;
    [super dealloc];
	
}

- (void) didOperationCompleted:(NSDictionary *)dict
{
	// stoping animating.
	if(bDataFetching){
		bDataFetching = FALSE;
		[self removeIndicator];
	}
	
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	if ([operation isEqualToString:@"GetDocumentDataResumedResult"]) {
		//AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	    //if([webservice getRecordCount]){	
		if([recordStack count]){
			//NSDictionary *record = [webservice getRecordAtIndex:0];
			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"GetDocumentDataResumedResult"];
			[self updateDocumentDetail:recordDict];
			//appDelegate.dictDetail = [recordDict copy];					
			[recordDict release];
			[self reloadFields];			
				
		}else{
			//[appDelegate messageBox:@"GetDocumentDataResumedResult Operation failure" Error:nil];
		}
	}	
		
}	

- (void)removeIndicator{
	[activityIndicator stopAnimating];
	activityIndicator.hidden = TRUE;
	
}

- (void)didOperationError:(NSError*)error
{

	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: [error localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
		
	// stoping animating.
	if(bDataFetching){
		bDataFetching = FALSE;
		[self removeIndicator];			
	}
}

-(BOOL)updateDocumentDetail:detailDict{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" 
						  inManagedObjectContext:appDelegate.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentId = %@", iDocumentId];
	[request setPredicate:predicate];
	NSError *error;
	NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
	[request release];	
	if (!results){
		NSLog(@"Error: %@", [error localizedDescription]);
		return FALSE;
	}
	//NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	if([results count] > 0){
		
		NSDictionary *Code = [detailDict objectForKey:@"Code"];
		NSDictionary *Subject = [detailDict objectForKey:@"Subject"];
		NSDictionary *GDBook = [detailDict objectForKey:@"GDBook"];
		NSDictionary *GDBook1 = [GDBook objectForKey:@"GDBook"];
		NSDictionary *DocumentType = [detailDict objectForKey:@"DocumentType"];
		NSDictionary *GDDocumentType1 = [DocumentType objectForKey:@"GDDocumentType"]; 
		NSDictionary *RegistryDate = [detailDict objectForKey:@"RegistryDate"]; 
		NSDictionary *EntityDoc = [detailDict objectForKey:@"EntityDoc"];
		NSDictionary *WorkflowState = [detailDict objectForKey:@"WorkflowState"];
		NSDictionary *WorkflowLabel = [WorkflowState objectForKey:@"WorkflowLabel"];
		
		NSString *formattedString = @"";
		NSString *tempStr = [RegistryDate objectForKey:@"value"];
		if([tempStr length] >= 10){
			NSString *strDate = [tempStr substringToIndex:10];			
			formattedString = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@":"];
		}else{
			formattedString = tempStr;
		}		
		
	    Document *doc = (Document *)[results objectAtIndex:0];	
		doc.documentName = [Subject objectForKey:@"value"];
		doc.documentCode = [Code objectForKey:@"value"];
		doc.documentSubject = [Subject objectForKey:@"value"];
		doc.documentDirection = [GDBook1 objectForKey:@"value"];
		doc.documentType = [GDDocumentType1 objectForKey:@"value"]; 
		doc.documentDate = formattedString;
		doc.documentEntry = [EntityDoc objectForKey:@"value"];
		doc.documentState= [WorkflowLabel objectForKey:@"value"];		
		error = nil;
		if (![appDelegate.managedObjectContext save:&error]) {
			NSLog(@"Error: %@", [error localizedDescription]);
			return FALSE;
		}
		NSLog(@"Find Document And Update OK: %@", iDocumentId);
	}
	return TRUE;
}

@end

