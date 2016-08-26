//
//  DocFilesViewController.m
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "DocFilesViewController.h"
#import "Constants.h"
#import "NSData+Base64.h"
#import "AppDelegate.h"
#import "RecordCache.h"

@implementation DocFilesViewController

@synthesize managingViewController; 
@synthesize webservice;
@synthesize documentId;

- (void)setDocumentId:(NSString *)doc{
	documentId = doc;	
}

- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"DocFilesViewController" bundle:nil]) {
        self.managingViewController = aViewController;
        self.title = @"Files";
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
	//	   
    if(appDelegate.reloadFiles){
		records = nil;
		bDataFetching = TRUE;
		appDelegate.reloadFiles = FALSE;
		[[self tableView] reloadData]; 
		[webservice wsListDocumentAttachments: hashCode DocumentID:documentId];
	}else{	
		records = [self fetchManagedObjectsWithPredicate];
		if([records count] == 0){ 
			records = nil;
			bDataFetching = TRUE;
			appDelegate.reloadFiles = FALSE;
			[[self tableView] reloadData]; 
			[webservice wsListDocumentAttachments: hashCode DocumentID:documentId];
		}		
		/*if(appDelegate.dictFiles == nil){
			//records = nil;
			bDataFetching = TRUE;
			[webservice wsListDocumentAttachments: hashCode DocumentID:documentId];				
		}else{
			if([appDelegate.dictFiles count] == 0){
				//records = nil;
				bDataFetching = TRUE;
				[webservice wsListDocumentAttachments: hashCode DocumentID:documentId];					
			}else{
				records = appDelegate.dictFiles;
			}
		}*/
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
	
    [super viewWillAppear:animated];
	
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
    if(records != nil)
		[records release];
	//if(fetchedResultsController != nil)
	//	[fetchedResultsController release];
	if(webservice != nil)
		[webservice release];
    [super dealloc];	
}


#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    //return [self.records count];
	if(records != nil)
		return [records count];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *kCustomCellID = @"AttachmentsCell";
    UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCustomCellID] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;			
	}	
	
	if(records != nil){
		if([records count] > 0){
			//NSMutableDictionary *item = [records objectAtIndex:indexPath.row];
			//cell.textLabel.text = [item objectForKey:@"Title"];
			//cell.imageView.image = [item objectForKey:@"Image"];
			//[item setObject:cell forKey:@"cell"];
			
			DocumentAttachment *attachment = [records objectAtIndex:indexPath.row];
			cell.textLabel.text = attachment.title;
			UIImage *iImage = [UIImage imageNamed: [NSString stringWithFormat:@"%@.png",
													attachment.attachmentExtension]];
			if(iImage == nil)
				iImage = [UIImage imageNamed: @"doc.png"];
			cell.imageView.image = iImage;
			//[item setObject:cell forKey:@"cell"];
			
			//BOOL checked = [[item objectForKey:@"checked"] boolValue];
			//UIImage *image = (checked) ? [UIImage imageNamed:@"download.png"] : [UIImage imageNamed:@"download.png"];
			UIImage *image = [UIImage imageNamed:@"download.png"];
			UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
			CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
			button.frame = frame;	// match the button's size with the image size
			[button setBackgroundImage:image forState:UIControlStateNormal];
			
			// set the button's target to the event handler.
			[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
			button.backgroundColor = [UIColor clearColor];
			cell.accessoryView = button;			
		}
	}
	// Set attributes common to all cell types.
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
	
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{	
	//if(fetchedResultsController == nil) return;
	//if(records != nil){		
	if([records count] > 0){			
		//NSMutableDictionary *item = [records objectAtIndex:indexPath.row];	
		//BOOL checked = [[item objectForKey:@"checked"] boolValue];			
		//[item setObject:[NSNumber numberWithBool:!checked] forKey:@"checked"];		
		//UITableViewCell *cell = [item objectForKey:@"cell"];
		//UIButton *button = (UIButton *)cell.accessoryView;
		
		//UIImage *newImage = (checked) ? [UIImage imageNamed:@"download.png"] : [UIImage imageNamed:@"download.png"];
		//[button setBackgroundImage:newImage forState:UIControlStateNormal];

		//NSString *title = [item objectForKey:@"Title"];
		DocumentAttachment *attachment = [records objectAtIndex:indexPath.row];
		// show dialog to download file.
		currentRow = indexPath.row;
		[self showConfirmAlert:attachment.title AttachmentId:@""];
		
	}	
}


#pragma mark -
#pragma mark Table View Delegate Methods

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
#if ALLOW_ATTACHMENT_ROW_DOWNLOAD	
	[self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
#endif	
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) didOperationCompleted:(NSDictionary *)dict
{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	
//	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if ([operation isEqualToString:@"DocFile"]) {
		//if([webservice getRecordCount]){	
		if([recordStack count]){
			//NSInteger i = 0, nResult = [webservice getRecordCount];
			NSInteger i = 0, nResult = [recordStack count];
			//NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
			
			//delete all caches with the condition.
			[self clearManagedObjectsWithPredicate];
			
			for(i = 0; i < nResult; i++){
				//NSDictionary *recordDict = [webservice getRecordAtIndex:i];
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"DocFile"];
				[self addAttachment:recordDict DocumentId:documentId];
				/*				
				NSDictionary *IDFile = [recordDict objectForKey:@"IDFile"];
				NSDictionary *FileName = [recordDict objectForKey:@"FileName"];
				NSDictionary *Extension = [recordDict objectForKey:@"Extension"];	
				NSString *recordName = [NSString stringWithFormat:	@"%@.%@",
								 [FileName objectForKey:@"value"],
								 [Extension objectForKey:@"value"]];
				
				NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];	
				[tempDict setValue: recordName forKey: @"Title"];
				[tempDict setValue: [IDFile objectForKey:@"value"] forKey: @"IDFile"];
				[tempDict setValue: [FileName objectForKey:@"value"] forKey: @"FileName"];
				[tempDict setValue: [Extension objectForKey:@"value"] forKey: @"Extension"];
				UIImage *rowImage;
				if(i == 2 || i == 5)
					rowImage = [UIImage imageNamed: @"doc.png"];
				if(i == 3)
					rowImage = [UIImage imageNamed: @"ppt.png"];
				else
					rowImage = [UIImage imageNamed: @"xls.png"];

				[tempDict setValue: NO forKey: @"checked"];				
				[tempDict setValue: rowImage forKey: @"Image"];
				[tmpArray addObject:tempDict];
				[tempDict release]; 
				[recordDict release];	
				 */
			}	
				
			//appDelegate.dictFiles = [tmpArray copy];	
			//[tmpArray release];
			
			//records = appDelegate.dictFiles;
			//[self fetchedResultsController:documentId];
			if(records != nil){
				[records release], records = nil;
			}			
			records = [self fetchManagedObjectsWithPredicate];
			//[records retain];
			[[self tableView] reloadData]; 				
			
		}else{
			//[appDelegate messageBox:@"GetAttachmentFile List Operation failure" Error:nil];
		}
		
	}else if ([operation isEqualToString:@"GetDocFileResult"]) {
		//if([webservice getRecordCount]){	
		if([recordStack count]){
			//TODO
			//NSDictionary *recordDict = [webservice getRecordAtIndex:0];	
			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"GetDocFileResult"];
			NSString *base64Data = [recordDict objectForKey:@"value"];
			NSLog(@"GetDocFileResult recordDict:%@",recordDict);
			NSLog(@"GetDocFileResult base64Data:%@",base64Data);
		}else{
           	//[appDelegate messageBox:@"GetDocFileResult Operation failure" Error:nil];
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

- (void)showConfirmAlert:(NSString *)attachment AttachmentId:(NSString*)key
{
	NSString *message = [NSString stringWithFormat:
					  @"Do you want to download:\n %@ ?",attachment];
	
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@""];
	[alert setMessage:message];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		 // Download attachments...
		 AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		 NSString *hashCode = appDelegate.hashCode;
		 if(webservice == nil){
		    webservice = [WebDocWebService instance];	
		 }
		
		 //NSMutableDictionary *item = [records objectAtIndex:currentRow];
		 //NSString *attachmentId = [item objectForKey:@"IDFile"];
		 //NSString *fileName = [item objectForKey:@"FileName"];
		 //NSString *extension = [item objectForKey:@"Extension"];	
		 DocumentAttachment *attachment = [records objectAtIndex:currentRow];
		BOOL isAttachment = ([attachment.isAttachment intValue] == 1) ? YES:NO;
		
		 [webservice setCurrentFileName: attachment.attachmentName];
		 //[webservice wsGetAttachmentFile: hashCode AttachmentID:attachment];
	 	 [webservice wsGetDocFile:hashCode DocumentID:attachment.attachmentId 
			FileName:attachment.attachmentName 
			Extension:attachment.attachmentExtension IsAnexo:isAttachment];	
		
	}	
}

- (void)clearManagedObjectsWithPredicate{
	//NSPredicate * allExcept = [NSPredicate predicateWithFormat:@"SELF != %@", exception];
	//NSArray *objects = [self fetchMyManagedObjectsWithPredicateOrNil:nil];
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DocumentAttachment" 
										  inManagedObjectContext:appDelegate.managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"documentId == %@", documentId];
	[request setPredicate:predicate];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:request error:NULL];
	for (NSManagedObject *object in objects) {
		[appDelegate.managedObjectContext deleteObject:object];
	}	
}

-(BOOL)addAttachment:(NSDictionary *)recordDict DocumentId:(NSString*)document{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	DocumentAttachment *attachment = (DocumentAttachment *)[NSEntityDescription 
						insertNewObjectForEntityForName:@"DocumentAttachment" 
						inManagedObjectContext:appDelegate.managedObjectContext];
	
	NSDictionary *IDFile = [recordDict objectForKey:@"IDFile"];
	NSDictionary *FileName = [recordDict objectForKey:@"FileName"];
	NSDictionary *Extension = [recordDict objectForKey:@"Extension"];
	NSString *isAttachmentStr = [[recordDict objectForKey:@"IsAttachment"] objectForKey:@"value"];
	NSString *titleName = [NSString stringWithFormat:	@"%@.%@",
							[FileName objectForKey:@"value"],
							[Extension objectForKey:@"value"]];			
		
	attachment.documentId = document;
	attachment.title = titleName;
	attachment.isAttachment = 
	[isAttachmentStr isEqualToString:@"false"]? [NSNumber numberWithInt:0]:[NSNumber numberWithInt:1];
	attachment.attachmentId = [IDFile objectForKey:@"value"];
	attachment.attachmentName = [FileName objectForKey:@"value"];
	attachment.attachmentExtension = [Extension objectForKey:@"value"];
	
	NSError *error = nil;
	if (![appDelegate.managedObjectContext save:&error]) {
		NSLog(@"Error:addAttachment.%@", [error localizedDescription]);
		return FALSE;
	}
	return TRUE;
}


- (NSArray *)fetchManagedObjectsWithPredicate{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"DocumentAttachment" 
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
		[NSEntityDescription entityForName:@"DocumentAttachment"
					inManagedObjectContext:context];
		[fetchRequest setEntity:entity];		
		
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"documentId == %@", iDocumentId]; 
		[fetchRequest setPredicate:pred];
		
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
											initWithKey:@"title" ascending:YES];
		[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		// clear cache.
		[NSFetchedResultsController deleteCacheWithName:@"Attachments"];
		
		NSFetchedResultsController *aFetchedResultsController = 
		[[NSFetchedResultsController alloc] 
		 initWithFetchRequest:fetchRequest 
		 managedObjectContext:context
		 sectionNameKeyPath:nil
		 cacheName:@"Attachments"];
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
