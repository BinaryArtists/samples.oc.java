//
//  DocListViewController.m
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "DocListViewController.h"
#import "DocumentDetailViewController.h"
#import "AppDelegate.h";
#import "WebService.h";
#import "Constants.h"
#import "RecordCache.h"

@implementation DocListViewController
@synthesize myTableView, tmpCell, prevButton, nextButton;
@synthesize parameters, controllers, webservice;

- (void)viewWillAppear:(BOOL)animated
{
	bFetching = FALSE;
	prevButton.enabled = FALSE;	
	nextButton.enabled = FALSE;	
	
	if(parameters == nil)
	   parameters = [[NSArray alloc] init];
				
	if(webservice == nil){
	   webservice = [WebDocWebService instance];	
	   webservice.delegate = self;	
	}
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *hashCode = appDelegate.hashCode; 
    NSString *currentView = appDelegate.currentView; 	
	
	if ([currentView isEqualToString:@"MyDocumentView"]) {	
		currentPage = appDelegate.myCurrentPage; 
		//get catched data.
		//NSMutableArray* tempArray = [appDelegate getPageController:currentPage];
		//NSFetchedResultsController* result = [self fetchedResultsController];
		NSArray *objects = [self fetchManagedObjectsWithPredicate];
		if([objects count] == 0){
			bFetching = TRUE;
			controllers = nil;	
			[myTableView reloadData];
			[webservice wsTotalMyDocuments:hashCode];
		}else{
			//[self makeControllers:tempArray];
			[self makeControllers:objects];
			[myTableView reloadData]; 
		}
	}else if([currentView isEqualToString:@"MyTeamDocumentView"]){
		currentPage = appDelegate.teamCurrentPage; 
		//get catched data.
		//NSMutableArray* tempArray = [appDelegate getPageController:currentPage];
		//if(tempArray == nil){
		NSArray *objects = [self fetchManagedObjectsWithPredicate];
		if([objects count] == 0){
			 bFetching = TRUE;
			 controllers = nil;
			 [myTableView reloadData];
	         NSString *strTeamId = [NSString stringWithFormat:@"%d",teamId];
			 [webservice wsTotalMyTeamDocuments:hashCode TeamId:strTeamId];			
		}else{
			[self makeControllers:objects];
			[myTableView reloadData]; 
		}	
	}else if([currentView isEqualToString:@"SearchDocumentView"]){
		controllers = nil;
		currentPage = appDelegate.searchCurrentPage; 
		//NSMutableArray* tempArray = [appDelegate getPageController:currentPage];
		//NSLog(@"***viewWillAppear tempArray:%@",tempArray);		
		//if(tempArray == nil){
		NSArray *objects = [self fetchManagedObjectsWithPredicate];
		if([objects count] == 0){
			//bFetching = TRUE;
			//controllers = nil;
			self.title = @"Search Results";			 
			//get catched search parameters.		
			if(appDelegate.searchParameters != nil){			
				NSString *code = [parameters objectAtIndex:0];
				NSString *state = [parameters objectAtIndex:1];
				NSString *direction = [parameters objectAtIndex:2];
				NSString *type = [parameters objectAtIndex:3];
				NSString *entity = [parameters objectAtIndex:4];	
				bFetching = TRUE;
				controllers = nil;
				[myTableView reloadData]; 
				if(currentPage == 0)
					currentPage++;
				[webservice wsAdvancedSearch:hashCode PageRowSize:200/*RECORD_PER_PAGE*/ CurrentPage:currentPage
								DocumentCode: code WorkflowState:state DocumentType:type Direction:direction Entity:entity];
				
			}else{
				[appDelegate messageBox:@"ERROR,SearchDocumentView parameters is nil!" Error:nil];	
			}
			
		}else{
			[self makeControllers:objects];
			[myTableView reloadData];
		}		
	}else{
		NSString *msg =[NSString stringWithFormat:@"ERROR,currentView:%@",currentView];
		[appDelegate messageBox:msg Error:nil];
	}
	
	if(currentPage == 0)
		currentPage = 1;
	
	if(bFetching){
		 activityIndicator = [[UIActivityIndicatorView alloc] 
		 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		 activityIndicator.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);		
	
		 activityIndicator.center = self.view.center;
		 [self.view addSubview: activityIndicator];
		 [activityIndicator startAnimating];				
	}
}

- (void)viewDidLoad {
	// Configure the table view.	
    self.myTableView.rowHeight = 73.0;
    self.myTableView.backgroundColor = [UIColor clearColor]; //DARK_BACKGROUND;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[super viewDidLoad];
}

- (void)viewDidUnload {
    controllers = nil;
	tmpCell = nil;
	prevButton = nil;
	nextButton = nil;
	myTableView = nil;
	activityIndicator = nil;	
    [super viewDidUnload];
}

- (void)dealloc {	
	[myTableView release];
	if(parameters != nil)
		[parameters release];
	//if(controllers != nil)
    //  [controllers release];
	if(fetchedResultsController != nil)
		[fetchedResultsController release];
	[webservice release];
    [super dealloc];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   return YES;    
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
	if(self.controllers == nil)
		return 0;
	else
        return [self.controllers count];
	
	//id <NSFetchedResultsSectionInfo> sectionInfo = nil;
 	//sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
 	//return [sectionInfo numberOfObjects];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ApplicationCell";
	
 	ApplicationCell *cell = (ApplicationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"DocumentCell" owner:self options:nil];
        cell = tmpCell;
        self.tmpCell = nil;
    }
	
	// Configure the cell
    NSUInteger row = [indexPath row];
	if(self.controllers != nil){
		
		DocumentDetailViewController *controller =  [controllers objectAtIndex:row];
		cell.useDarkBackground = (indexPath.row % 2 == 0);	
		// Configure the data for the cell.
		
		//NSDictionary *recordDict = [controller getDocumentData];
		//NSDictionary *Code = [recordDict objectForKey:@"Code"];	
		//cell.icon = controller.rowImage;
		//cell.code = [Code objectForKey:@"value"]; 
		cell.name = controller.title;
		cell.icon = [UIImage imageNamed: controller.document.documentIcon];
		cell.code = controller.document.documentCode;
		 		
	}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    return cell;	
	
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = ((ApplicationCell *)cell).useDarkBackground ? DARK_BACKGROUND : LIGHT_BACKGROUND;
	cell.backgroundColor = ((ApplicationCell *)cell).useDarkBackground ? [UIColor darkGrayColor] : [UIColor clearColor];
}


#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    NSUInteger row = [indexPath row];
	
	if(self.controllers != nil){
		
		DocumentDetailViewController *nextController = [self.controllers
													 objectAtIndex:row];
		
		//preload detail, attachment and history.
		[nextController preLoadData];
				
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
						initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release]; 
				
		//clear cache
		[self handleWithCache];
		
		//push document detail view...
		[self.navigationController pushViewController:nextController animated:YES];
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row = [indexPath row];
	NSString *text = @"";
	if(controllers != nil){
	   DocumentDetailViewController *controller =  [controllers objectAtIndex:row];	
	   text = controller.title;	
	}
	CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	CGFloat height = MAX(size.height, 44.0f);
	return (height + (CELL_CONTENT_MARGIN * 2) - 19.0 + 2);
}

#pragma mark -
#pragma mark Class Public Methods
- (void)setParameters:(NSArray *)args
{
	parameters = args;
	[parameters retain];
}

- (void)setTeamId:(NSInteger)team{
	teamId = team;
}

- (void)setTeamName:(NSString *)team{
	teamName = team;
}

- (void)makeControllers:(NSMutableArray*)objects
{
	NSInteger i = 0;
	//	NSInteger nResult = [array count];		
	//if(fetchedResultsController == nil) return;
	//int nResult = fetchedResultsController.fetchedObjects.count;	
	NSInteger nResult = [objects count];
	NSLog(@"***makeControllers,nResult:%d", nResult);
	if(nResult < 1) {
		prevButton.enabled = FALSE;
		nextButton.enabled = FALSE;
		return;	
	}
	NSString *viewControllerName = @"DocumentDetailViewController";
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *currentView = appDelegate.currentView;
	if ([currentView isEqualToString:@"MyDocumentView"]) {
		//totalPage = appDelegate.myTotalPage;
		totalPage = [self makeTotalPage:appDelegate.myTotalPage];
		self.title = [NSString stringWithFormat:@"Documents To Me(%d)", appDelegate.myTotalPage];
	}else if([currentView isEqualToString:@"MyTeamDocumentView"]){
		//totalPage = appDelegate.teamTotalPage;
		totalPage = [self makeTotalPage:appDelegate.teamTotalPage];
		self.title = [NSString stringWithFormat:@"%@(%d)",teamName, appDelegate.teamTotalPage];
	}else if([currentView isEqualToString:@"SearchDocumentView"]){
		//totalPage = appDelegate.searchTotalPage;
		totalPage = [self makeTotalPage:appDelegate.searchTotalPage];
		self.title = [NSString stringWithFormat:@"Advanced Search(%d)", appDelegate.searchTotalPage];
	}
	if(controllers != nil) {
		[controllers release];
		controllers = nil;
	}
	controllers = [[NSMutableArray alloc] init];
		
	for(i = 0; i < nResult; i++){
		/*NSDictionary *recordDict = [array objectAtIndex:i];	
		 NSDictionary *Subject = [recordDict objectForKey:@"Subject"];
		 NSDictionary *Deadline = [recordDict objectForKey:@"Deadline"];
		 NSString *strDeadline = [Deadline objectForKey:@"value"];						
		 NSInteger iDeadLine = [strDeadline intValue];
		 //iDeadLine  = i;
		 if(iDeadLine > 5)
		 iDeadLine = iDeadLine%5;
		 NSString *imgName = [NSString stringWithFormat:@"deadline%d.png",iDeadLine];
		 */		
		//------------------------			
		//set values to details tabs.	
		//[appDelegate setCurrentTitle:[Subject objectForKey:@"value"]];
		DocumentDetailViewController *presidentsViewController = 
		[[NSClassFromString(viewControllerName) alloc] 
		 initWithNibName:viewControllerName bundle:nil];
		
		//presidentsViewController.title = [Subject objectForKey:@"value"]; 
		//[presidentsViewController setDocumentData:recordDict];
		//presidentsViewController.rowImage = [UIImage imageNamed: imgName];
		//[recordDict release];	
		
		//Document *doc = [fetchedResultsController.fetchedObjects objectAtIndex:i];
		Document *doc = [objects objectAtIndex:i]; 
//		NSLog(@"***makeControllers:%@",doc.category);
		//[appDelegate setCurrentTitle:doc.documentSubject];
		presidentsViewController.title = doc.documentName;
		[presidentsViewController setDocument:doc];
		[controllers addObject:presidentsViewController];
		[presidentsViewController release]; 				  
	}
	
//	totalPage = ceil(totalRecords/RECORD_PER_PAGE);
//	if(totalPage < 1)
//		totalPage = 1;
//	if(totalRecords%RECORD_PER_PAGE != 0 && totalPage > 1)
//		totalPage++;
//	NSLog(@"page_count:%d",totalPage);	
	
	if((currentPage-1) < 1){
		prevButton.enabled = FALSE;	
	}else{
		if(totalPage > 0)
		   prevButton.enabled = TRUE;	
	}
	if((currentPage+1) > totalPage){
		nextButton.enabled = FALSE;	
	}else{
		if(totalPage > 0)
			nextButton.enabled = TRUE;	
	}
	
}

- (void)handleWithCache
{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if(appDelegate.dictDetail != nil){	
		[appDelegate.dictDetail release];
		appDelegate.dictDetail = nil;		
	}	
	if(appDelegate.dictFiles != nil){	
		[appDelegate.dictFiles release];
		appDelegate.dictFiles = nil;		
	}
	if(appDelegate.dictHistory != nil){	
		[appDelegate.dictHistory release];
		appDelegate.dictHistory = nil;		
	}
	if(appDelegate.dictWorkflow != nil){	
		[appDelegate.dictWorkflow release];
		appDelegate.dictWorkflow = nil;		
	}
	
}

- (NSInteger)makeTotalPage:(int)totalRecords{
	NSInteger result = ceil(totalRecords/RECORD_PER_PAGE);
	if(result < 1)
		result = 1;
	if(totalRecords%RECORD_PER_PAGE != 0 && result > 1)
		result++;
	NSLog(@"page_count:%d",result);
	return result;
}

- (void)didOperationCompleted:(NSDictionary *)dict
{
	NSInteger i = 0, nResult = 0;
	if(currentPage == 0)
	   currentPage = 1;
//	NSNumber *page = [dict objectForKey:@"page"];
	NSNumber *team = [dict objectForKey:@"team"];
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	
	//NSLog(@"didOperationCompleted operation:%@",operation);
	//NSLog(@"didOperationCompleted recordStack:%@",recordStack);
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *hashCode = appDelegate.hashCode; 
	if ([operation isEqualToString:@"TotalMyDocumentsResult"]) {

		if([recordStack count]){

			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"TotalMyDocumentsResult"];
			NSString *strResult = [recordDict objectForKey:@"value"];						
			appDelegate.myTotalPage = [strResult intValue]; 	
			//appDelegate.myTotalPage = [self makeTotalPage:[strResult intValue]]; 
			NSLog(@"totalRecords = %d",[strResult intValue]);			
			//
			[webservice wsListMyDocuments:hashCode PageRowSize:RECORD_PER_PAGE CurrentPage:currentPage];
		}else{
			prevButton.enabled = FALSE;
			nextButton.enabled = FALSE;
			[self removeIndicator];	
		}				
	}
	else if ([operation isEqualToString:@"TotalMyTeamDocumentsResult"]) {

		if([recordStack count]){

			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"TotalMyTeamDocumentsResult"];
			NSString *strResult = [recordDict objectForKey:@"value"];						
			appDelegate.teamTotalPage =  [strResult intValue];  
			//appDelegate.teamTotalPage = [self makeTotalPage:[strResult intValue]]; 
			NSLog(@"totalRecords = %d",[strResult intValue]);
			//
			[webservice wsListMyDocumentsByDepartment:hashCode 
						PageRowSize:RECORD_PER_PAGE CurrentPage:currentPage TeamID:teamId];		

		}else{			
			prevButton.enabled = FALSE;
			nextButton.enabled = FALSE;
			[self removeIndicator];	
		}		
		
	}	
	else if ([operation isEqualToString:@"GDDocument"]) {

		if([recordStack count]){

			nResult = [recordStack count];
			NSLog(@"didOperationCompleted,nResult = %d", nResult);
			NSString *currentView = appDelegate.currentView;
			NSString *iCategory = @"";
			if ([currentView isEqualToString:@"MyDocumentView"]) {
				iCategory = MyDocument;				
			}else if([currentView isEqualToString:@"MyTeamDocumentView"]){
				iCategory = MyTeamDocument;
			}else if([currentView isEqualToString:@"SearchDocumentView"]){
				iCategory = SearchDocument;
				NSLog(@"totalRecords = %d", nResult);
				//appDelegate.searchTotalPage = [self makeTotalPage:nResult];	
				appDelegate.searchTotalPage = nResult;
			}
		    //delete all caches with the condition.
			[self clearManagedObjectsWithPredicate:nil];
			
			//NSMutableArray *tmpArray = [[NSMutableArray alloc] init];	
			//NSString *viewControllerName = @"DocumentDetailViewController";
			//loop through all records.
			int iCurrentPage = 1;
			for(i = 0; i < nResult; i++){
				//NSDictionary *recordDict = [webservice getRecordAtIndex:i];	
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"GDDocument"];
				//NSDictionary *Code = [recordDict objectForKey:@"Code"];
				NSDictionary *Subject = [recordDict objectForKey:@"Subject"];
				//NSString *recordName = [NSString stringWithFormat:
										//@"%@|%@", [Code objectForKey:@"value"],
										//[Subject objectForKey:@"value"]];				
				//NSDictionary *Deadline = [recordDict objectForKey:@"Deadline"];
				//NSString *strDeadline = [Deadline objectForKey:@"value"];						
				//NSInteger iDeadLine = [strDeadline intValue];
				//iDeadLine  = i;
				//if(iDeadLine > 5)
				//  iDeadLine = iDeadLine%5;
				//NSString *imgName = [NSString stringWithFormat:@"deadline%d.png",iDeadLine];
				//-----------------------------------------------------------------------------	
				//NSLog(@"addDocument ===> currentPage: %d",currentPage);
				if(i > RECORD_PER_PAGE-1){
					if(i%RECORD_PER_PAGE == 0){
						iCurrentPage++;
					}
				}				
				
				if([iCategory isEqualToString:SearchDocument]){
				   [self addDocument:[NSNumber numberWithInt:iCurrentPage] Team:team Data:recordDict Category:iCategory];
				}else{
				   [self addDocument:[NSNumber numberWithInt:currentPage] Team:team Data:recordDict Category:iCategory];
				}
				//set values to details tabs.	
				   [appDelegate setCurrentTitle:[Subject objectForKey:@"value"]];
				
				   // DocumentDetailViewController *presidentsViewController = 
				    //         [[NSClassFromString(viewControllerName) alloc] 
					//          initWithNibName:viewControllerName bundle:nil];
				   // presidentsViewController.title = [Subject objectForKey:@"value"]; 
				   // [presidentsViewController setDocumentData:recordDict];
				   // presidentsViewController.rowImage = [UIImage imageNamed: imgName];
				   //[recordDict release];							
				   //[tmpArray addObject:recordDict];	
				   [recordDict release];
				   //[presidentsViewController release]; 				    				
				   //-----------------------------------------------------------------------------									   
			  }
			  			
			  //stored in cache
			  //[appDelegate addPageController:tmpArray];
			  //[tmpArray release];
			
			  [self setCurrentPage];
			 // NSMutableArray *temp = [appDelegate getPageController:currentPage];
			  NSArray *objects = [self fetchManagedObjectsWithPredicate];			
			  [self makeControllers:objects];
			  //refresh table view
		       [myTableView reloadData]; 			   
			  			
		}else{
			//[appDelegate messageBox:@"ListDocument Operation failure" Error:nil];
		}		
		// stoping animating.
		if(bFetching){
			bFetching = FALSE;
			[self removeIndicator];				
		}
	}else{
		// stoping animating.
		if(bFetching){
			bFetching = FALSE;
			[self removeIndicator];		
		}
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
	
	if(bFetching){
		bFetching = FALSE;
		[self removeIndicator];	
	}	
	
}

- (void)setCurrentPage{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *currentView = appDelegate.currentView; 
	if ([currentView isEqualToString:@"MyDocumentView"]) {
		appDelegate.myCurrentPage = currentPage;
	}else if ([currentView isEqualToString:@"MyTeamDocumentView"]) {
		appDelegate.teamCurrentPage = currentPage;
	}else if ([currentView isEqualToString:@"SearchDocumentView"]) {
		appDelegate.searchCurrentPage = currentPage;
	}	
}

- (void)previousAction:(id)sender
{
	if(webservice == nil)
		return;
	nextButton.enabled = TRUE;	
	NSInteger tmpPage = currentPage - 1;
	NSLog(@"currentPage: %d,totalPage:%d",currentPage, totalPage);
	if(tmpPage < 1){
		prevButton.enabled = FALSE;	
	}else{
		currentPage--;	
		[self setCurrentPage];		
		[self viewWillAppear:NO];
	}	
}

- (void)nextAction:(id)sender
{
	if(webservice == nil)
		return;
	prevButton.enabled = TRUE;
	NSInteger tmpPage = currentPage+1;
	NSLog(@"currentPage: %d,totalPage:%d",currentPage, totalPage);
   	if(tmpPage > totalPage){
		nextButton.enabled = FALSE;	
	}else{		
		currentPage++;
		[self setCurrentPage];
		[self viewWillAppear:NO];
	}	
}

#pragma mark -
#pragma mark FRC delegate methods
/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[myTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController*)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
 	NSIndexSet *set = [NSIndexSet indexSetWithIndex:sectionIndex];
 	switch(type) {
		case NSFetchedResultsChangeInsert:
			[myTableView insertSections:set
							withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[myTableView deleteSections:set
							withRowAnimation:UITableViewRowAnimationFade];
			break;
 	}
}

- (void)configureCell:(UITableViewCell *)cell withTrack:(Document *)document {
	((ApplicationCell*)cell).name = document.documentName;
	((ApplicationCell*)cell).icon = [UIImage imageNamed: document.documentIcon];
	((ApplicationCell*)cell).code = document.documentCode;	
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject 
       atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type 
      newIndexPath:(NSIndexPath *)newIndexPath {
	
	if(NSFetchedResultsChangeUpdate == type) {
		[self configureCell:[myTableView cellForRowAtIndexPath:indexPath]
				  withTrack:anObject];
	} else if(NSFetchedResultsChangeMove == type) {
		[myTableView reloadSections:[NSIndexSet indexSetWithIndex:0]
		 withRowAnimation:UITableViewRowAnimationFade];
	} else if(NSFetchedResultsChangeInsert == type) {
		if(!firstInsert) {
			[myTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
			 withRowAnimation:UITableViewRowAnimationRight];
		} else {
			[myTableView insertSections:[[NSIndexSet alloc] initWithIndex:0] 
			 withRowAnimation:UITableViewRowAnimationRight];
		}
	} else if(NSFetchedResultsChangeDelete == type) {
		NSInteger sectionCount = [[fetchedResultsController sections] count];
		if(0 == sectionCount) {
			NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:indexPath.section];
			[myTableView deleteSections:indexes
			 withRowAnimation:UITableViewRowAnimationFade];
		} else {
			[myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
			 withRowAnimation:UITableViewRowAnimationFade];
		}
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[myTableView endUpdates];
}
*/

#pragma mark -
#pragma mark Core DAta API
-(BOOL)addDocument:(NSNumber*)page Team:(NSNumber*)team Data:(NSDictionary *)dict Category:(NSString*)category{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	Document *doc = (Document *)[NSEntityDescription insertNewObjectForEntityForName:@"Document" 
								  inManagedObjectContext:appDelegate.managedObjectContext];
	
	NSDictionary *Code = [dict objectForKey:@"Code"];
	NSDictionary *Subject = [dict objectForKey:@"Subject"];
	//NSString *recordName = [NSString stringWithFormat:
	//                @"%@|%@", [Code objectForKey:@"value"],
	//                [Subject objectForKey:@"value"]];				
	NSDictionary *Deadline = [dict objectForKey:@"Deadline"];
	NSString *strDeadline = [Deadline objectForKey:@"value"];						
	NSInteger iDeadLine = [strDeadline intValue];	
	if(iDeadLine > 5)
	    iDeadLine = iDeadLine%5;
	NSString *imgName = [NSString stringWithFormat:@"deadline%d.png",iDeadLine];
//	NSLog(@"addDocument ===> page: %@",category);
	doc.category = category;
	doc.createDate = [appDelegate getCurrentDateTime];
	doc.page = page;
	doc.teamId = team;	
	doc.documentId = [[dict objectForKey:@"IDGDDocument"] objectForKey:@"value"];
	doc.documentIcon = imgName;
	doc.documentCode = [Code objectForKey:@"value"];
	doc.documentName = [Subject objectForKey:@"value"];//recordName;
		
	NSError *error = nil;
	if (![appDelegate.managedObjectContext save:&error]) {
		NSLog(@"Error: %@", [error localizedDescription]);
		[appDelegate messageBox: [error localizedDescription] Error:nil];
		return FALSE;
	}
	return TRUE;
}

- (NSPredicate *)createPredicate{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *iCategory = @"xxx";
	NSString *currentView = appDelegate.currentView; 
	NSPredicate *predicate;
	if ([currentView isEqualToString:@"MyDocumentView"]) {
		iCategory = MyDocument;
		predicate = [NSPredicate predicateWithFormat:@"page == %d AND category == %@",
					  currentPage, iCategory];
	}else if([currentView isEqualToString:@"MyTeamDocumentView"]){	
		iCategory = MyTeamDocument;
		predicate = [NSPredicate predicateWithFormat:@"page == %d AND teamId == %d AND category == %@",
					 currentPage, teamId, iCategory];
	}else if([currentView isEqualToString:@"SearchDocumentView"]){
		iCategory = SearchDocument;
		predicate = [NSPredicate predicateWithFormat:@"page == %d AND category == %@",
					 currentPage, iCategory];
	}
	return predicate;
}

- (NSArray *)fetchManagedObjectsWithPredicate{
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//	NSString *iCategory = MyDocument;
//	NSString *currentView = appDelegate.currentView; 
//	if ([currentView isEqualToString:@"MyDocumentView"]) {
//		iCategory = MyDocument;
//	}else if([currentView isEqualToString:@"MyTeamDocumentView"]){	
//		iCategory = MyTeamDocument;
//	}else if([currentView isEqualToString:@"SearchDocumentView"]){
//		iCategory = SearchDocument;
//	}	
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" 
											  inManagedObjectContext:appDelegate.managedObjectContext];
	[request setEntity:entity];
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"page == %d AND category == %@",
	//						  currentPage, iCategory];
	[request setPredicate:[self createPredicate]];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:request error:NULL];
	//NSLog(@"**** fetchManagedObjectsWithPredicate, objects: %@", objects);
	return objects;
}

- (void)clearManagedObjectsWithPredicate:(NSManagedObject*)except{
	//NSPredicate * allExcept = [NSPredicate predicateWithFormat:@"SELF != %@", exception];
	//NSArray *objects = [self fetchMyManagedObjectsWithPredicateOrNil:nil];
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSArray *objects = [self fetchManagedObjectsWithPredicate];	
	for (NSManagedObject *object in objects) {
		[appDelegate.managedObjectContext deleteObject:object];
	}	
}


- (NSFetchedResultsController*)fetchedResultsController{
	
	if (fetchedResultsController != nil) {
		//firstInsert = [fetchedResultsController.sections count] == 0;
		return fetchedResultsController;
	}
	
	if (nil == fetchedResultsController) {
		AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSManagedObjectContext *context = appDelegate.managedObjectContext;
		NSEntityDescription *entity = 
		[NSEntityDescription entityForName:@"Document"
					inManagedObjectContext:context];
		[fetchRequest setEntity:entity];
		
//		NSString *iCategory = MyDocument;
//		NSString *currentView = appDelegate.currentView; 
//		if ([currentView isEqualToString:@"MyDocumentView"]) {
//			iCategory = MyDocument;
//		}else if([currentView isEqualToString:@"MyTeamDocumentView"]){	
//			iCategory = MyTeamDocument;
//		}else if([currentView isEqualToString:@"SearchDocumentView"]){
//			iCategory = SearchDocument;
//		}
		// clear cache.
		[NSFetchedResultsController deleteCacheWithName:@"Documents"];
				
//		NSPredicate *pred = [NSPredicate predicateWithFormat:@"page == %d AND category == %@",
//							 currentPage, iCategory]; 
		[fetchRequest setPredicate:[self createPredicate]];
		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
											initWithKey:@"documentSubject" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
				
		NSFetchedResultsController *aFetchedResultsController = 
		                         [[NSFetchedResultsController alloc] 
									 initWithFetchRequest:fetchRequest 
											managedObjectContext:context
											  sectionNameKeyPath:nil
													   cacheName:@"Documents"];
		//aFetchedResultsController.delegate = self;
		fetchedResultsController = aFetchedResultsController;		
		[fetchedResultsController retain];
		NSError *error = nil;
		if (![fetchedResultsController performFetch:&error]) {
			NSLog(@"Error: %@", [error localizedDescription]);
			fetchedResultsController = nil;
		}
		[aFetchedResultsController release], aFetchedResultsController = 0;
		[fetchRequest release];
		[sortDescriptor release];
		
		NSLog(@"fetchedResultsController.fetchedObjects: %@", fetchedResultsController.fetchedObjects);
	}	
	//firstInsert = [fetchedResultsController.sections count] == 0;
	return fetchedResultsController;
	
}    


@end
