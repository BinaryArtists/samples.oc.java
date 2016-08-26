//
//  DocHistoryViewController.m
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "DocHistoryViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "RecordCache.h"

@implementation DocHistoryViewController
@synthesize webservice;
@synthesize documentId;  //, records;
@synthesize managingViewController;  

- (void)setDocumentId:(NSString *)doc{
	documentId = doc;	
}

- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"DocHistoryViewController" bundle:nil]) {
        self.managingViewController = aViewController;
        self.title = @"History";
		records = nil;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
	if(webservice == nil){
		webservice = [WebDocWebService instance];				
	}
	webservice.delegate = self;	
	
	bDataFetching = FALSE;
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *hashCode = appDelegate.hashCode;
		
	if(records != nil){
		[records release], records = nil;
	}	
	records = [self fetchManagedObjectsWithPredicate];
	//if(	appDelegate.dictHistory == nil){	
	if([records count] == 0){   
		//records = nil;
		bDataFetching = TRUE;
	    [webservice wsListFileHistory: hashCode DocumentID:documentId];	    
	}else{
		/*if(	[appDelegate.dictHistory count] == 0){		
			records = nil;
			bDataFetching = TRUE;
			[webservice wsListFileHistory: hashCode DocumentID:documentId];
			
		}else{
			records = appDelegate.dictHistory;			
		}*/
		//[[self tableView] reloadData];
	}
	
	//start animating...
	if(bDataFetching){
		activityIndicator = [[UIActivityIndicatorView alloc] 
							 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);		
		activityIndicator.center = self.view.center;
		[self.view addSubview: activityIndicator];
		[activityIndicator startAnimating];		
	}
	

}

- (void)viewDidLoad {
    [super viewDidLoad];	
	
}

- (void)viewDidUnload {
   // self.records = nil;
	[self removeIndicator];
    [super viewDidUnload];	
}

- (void)dealloc {
    self.managingViewController = nil;
	if(records != nil)
	   [records release];
	//if(fetchedResultsController != nil)
	//	[fetchedResultsController release];
	[webservice release];
    [super dealloc];	
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
 	if(records != nil)
		return [records count];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AttachmentsCell= @"HistoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: 
                             AttachmentsCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                       reuseIdentifier: AttachmentsCell] autorelease];
    }

	if(records != nil){	
			// Configure the cell
			NSUInteger row = [indexPath row];
		  	
//			NSDictionary *recordDict = [records objectAtIndex:row];
//			NSDictionary *MovimentHistory = [recordDict objectForKey:@"MovimentHistory"];
//			NSDictionary *DateHistory = [recordDict objectForKey:@"DateHistory"];	
			//-------------------------------------------------------------
//		    NSString *formattedString = @"";
//			NSString *tempStr = [DateHistory objectForKey:@"value"];
//			if([tempStr length] >= 10){
//				NSString *strDate = [tempStr substringToIndex:10];
				/*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy:MM:dd"];	
				NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
				[dateFormatter setLocale:locale];
				NSDate *newDate = [dateFormatter dateFromString:strDate];
				formattedString = [dateFormatter stringFromDate:newDate];
				NSLog(@"strDate:%@,newDate:%@,formattedString:%@", strDate,newDate,formattedString);		
				[dateFormatter release];*/
//				formattedString = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@":"];
//			}else{
//				formattedString = tempStr;
//			}
		    //-------------------------------------------------------------
//		    NSString *title = [NSString stringWithFormat:	@"%@\n%@",
//						   formattedString/*[DateHistory objectForKey:@"value"]*/,
//						   [MovimentHistory objectForKey:@"value"]];
		    DocumentHistory *history = [records objectAtIndex:row];		
		    cell.textLabel.text = history.historyText; //formattedString; 
		    cell.detailTextLabel.text = history.historyTitle;//title;
			cell.detailTextLabel.numberOfLines = 2;
			cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			
	}	
    return cell;
}

- (void)takeNewString:(NSString *)newValue{
	//commentField.text = newValue;	
}

- (UINavigationController *)navController{
	return self.managingViewController.navigationController;
}

- (void)tableView:(UITableView *)tableView 
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    	
	NSUInteger row = [indexPath row];
	
//	NSDictionary *recordDict = [records objectAtIndex:row];
//	NSDictionary *MovimentHistory = [recordDict objectForKey:@"MovimentHistory"];
//	NSDictionary *DateHistory = [recordDict objectForKey:@"DateHistory"];	
//	NSString *title = [NSString stringWithFormat:	@"%@\n%@",
//					   [DateHistory objectForKey:@"value"],
//					   [MovimentHistory objectForKey:@"value"]];
	//NSString *date = [DateHistory objectForKey:@"value"]; 
	//cell.detailTextLabel.text = title;
	
	DocumentHistory *history = [records objectAtIndex:row];
	
	LongTextFieldViewController *controller = 
	[[LongTextFieldViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;	
	controller.string = history.historyTitle;	
	controller.isHistory = TRUE;
	[self.managingViewController.navigationController pushViewController:controller animated:YES];
	[controller release];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     // You will also need to return a suitable height for the multi-line cell. 
     //A height of (44.0 + (numberOfLines - 1) * 19.0) should work fine. 
	 int numberOfLines = 2;
     return (44.0 + (numberOfLines - 1) * 19.0);
}

- (void) didOperationCompleted:(NSDictionary *)dict
{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	
//	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if ([operation isEqualToString:@"MovimentHistory"]) {

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			//NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
			[self clearManagedObjectsWithPredicate];
			for(i = 0; i < nResult; i++){
				//NSDictionary *recordDict = [webservice getRecordAtIndex:i];
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"MovimentHistory"];
				//[tmpArray addObject:recordDict];
				[self addHistory:recordDict DocumentId:documentId];
			}				 
			
			//appDelegate.dictHistory = [tmpArray copy];
			//[tmpArray release];			
			//records = appDelegate.dictHistory;
			if(records != nil){
				[records release], records = nil;
			}
			records = [self fetchManagedObjectsWithPredicate];
			//[records retain];
			[[self tableView] reloadData];
			
		}else{
			//[appDelegate messageBox:@"DocHistoryViewController Operation failure" Error:nil];
		}		
	}
	
	// stoping animating.
	if(bDataFetching){
		bDataFetching = FALSE;
		[self removeIndicator];
	}			
	
}	

- (void)removeIndicator{
	if(activityIndicator != nil){
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator = nil;		
	}
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

- (void)clearManagedObjectsWithPredicate{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DocumentHistory" 
											  inManagedObjectContext:appDelegate.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentId == %@", documentId];
	[request setPredicate:predicate];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:request error:NULL];
	for (NSManagedObject *object in objects) {
		[appDelegate.managedObjectContext deleteObject:object];
	}	
}

- (BOOL)addHistory:(NSDictionary *)recordDict DocumentId:(NSString*)document{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	DocumentHistory *history = (DocumentHistory *)[NSEntityDescription 
				insertNewObjectForEntityForName:@"DocumentHistory" 
				inManagedObjectContext:appDelegate.managedObjectContext];
	
	NSDictionary *MovimentHistory = [recordDict objectForKey:@"MovimentHistory"];
	NSDictionary *DateHistory = [recordDict objectForKey:@"DateHistory"];	
	//-------------------------------------------------------------
	NSString *formattedString = @"";
	NSString *tempStr = [DateHistory objectForKey:@"value"];
	NSString *strDate2 = @"";
	if([tempStr length] >= 10){
		NSString *strDate = [tempStr substringToIndex:10];
		if([tempStr length] >= 16){
		     strDate2 = [tempStr substringToIndex:16];
			 strDate2 = [strDate2 stringByReplacingOccurrencesOfString:@"T" withString:@" "];
		}
		formattedString = [strDate stringByReplacingOccurrencesOfString:@"-" withString:@":"];
	}else{		
		formattedString = tempStr;
	}
	//-------------------------------------------------------------
	//NSString *strDate2 = ([tempStr length] >= 16)? [tempStr substringToIndex:16]:tempStr;	
	NSString *title = [NSString stringWithFormat:	@"%@\n%@",
					   strDate2/*[DateHistory objectForKey:@"value"]*/,
					   [MovimentHistory objectForKey:@"value"]];
	history.documentId = document;
	history.historyText = formattedString;//[DateHistory objectForKey:@"value"]; 
	history.historyTitle = title;		
		
	NSError *error = nil;
	if (![appDelegate.managedObjectContext save:&error]) {
		NSLog(@"Error:addHistory, %@", [error localizedDescription]);
		return FALSE;
	}
	return TRUE;
}

- (NSArray *)fetchManagedObjectsWithPredicate{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DocumentHistory" 
											  inManagedObjectContext:appDelegate.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"documentId == %@", documentId]; 
	[request setPredicate:pred];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:request error:NULL];
	NSArray *result = [objects copy];
	return result;
}

- (NSFetchedResultsController*)fetchedResultsController:(NSString*)iDocumentId{
	/*
	if (fetchedResultsController != nil) {		
		return fetchedResultsController;
	}
	
	if (nil == fetchedResultsController) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *context = appDelegate.managedObjectContext;
		NSEntityDescription *entity = 
		[NSEntityDescription entityForName:@"DocumentHistory"
					inManagedObjectContext:context];
		[fetchRequest setEntity:entity];		
		
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"documentId == %@", iDocumentId]; 
		[fetchRequest setPredicate:pred];
		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
											initWithKey:@"historyTitle" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		// clear cache.
		[NSFetchedResultsController deleteCacheWithName:@"Historys"];
		NSFetchedResultsController *aFetchedResultsController = 
		[[NSFetchedResultsController alloc] 
		 initWithFetchRequest:fetchRequest 
		 managedObjectContext:context
		 sectionNameKeyPath:nil
		 cacheName:@"Historys"];
		//aFetchedResultsController.delegate = self;
		fetchedResultsController = aFetchedResultsController;		
		[fetchedResultsController retain];
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error]) {
			NSLog(@"Error: %@", [error localizedDescription]);
			fetchedResultsController = nil;
		}
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
	}	
	
	return fetchedResultsController;
	*/
	return nil;
}


@end


