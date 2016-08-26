//
// File: AdvancedSearchViewController.m
// Abstract: The view controller for advanced search.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import "AdvancedSearchViewController.h"
#import "Constants.h"
#import "UIComboBox.h"
#import "AppDelegate.h"
#import "DocListViewController.h"
#import "NSData+Base64.h"

#define STATUS_FIELD 3000
#define DIRECT_FIELD 3001
#define TYPE_FIELD 3002

@implementation AdvancedSearchViewController

@synthesize webservice;
@synthesize searchIndicator, searchButton;
@synthesize codeField, directionField, stateField, typeField, entryField;
@synthesize targetViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    self.title = NSLocalizedString(@"Advanced Search", @"");
	return self;
}

- (void)dealloc
{
	[self.stateField pickerViewHiddenIt:YES];
	[self.directionField pickerViewHiddenIt:YES];
	[self.typeField pickerViewHiddenIt:YES];	
	if(targetViewController != nil)
	  [targetViewController release];
	[states release];
	[directions release];
	[types release];
	[webservice release];
	[super dealloc];
}

- (void)viewDidLoad
{
	//do nothing.	
	searchIndicator.hidden = TRUE;	
	searchButton.enabled = TRUE;	
}

- (void)viewDidUnload {
   stateField = nil;
   directionField = nil;
   typeField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
	searchIndicator.hidden = TRUE;	
	searchButton.enabled = TRUE;	
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	states = [[appDelegate getWorkflowStates] copy];
	directions = [[appDelegate getDirections] copy];
	types = [[appDelegate getTypes] copy];
	
	stateField.formatString = @"%@ %@ %@";	
	directionField.formatString = @"%@ %@ %@";	
	typeField.formatString = @"%@ %@ %@";	
	if(webservice == nil){
	   webservice = [WebDocWebService instance];	
	   webservice.delegate = self;	
	}	
}

- (void)viewDidAppear:(BOOL)animated
{
	//set all filed to blank as default.
	int i = 0;
	NSString *defaultValue = @"0";
	// AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	// get the search parameters...
	//NSArray *parameters = appDelegate.searchParameters;  
	//if([parameters count]){			
		//defaultValue = [parameters objectAtIndex:1];
		for(i = 0; i< [states count]; i++){
			NSArray *crayon = [[states objectAtIndex:i] componentsSeparatedByString:@"#"];
			NSString *stateId = [crayon objectAtIndex:0];
			if ([stateId isEqualToString:defaultValue]) {			
				[stateField selectRow:i inComponent:0 animated:NO];
				break;
			}
		}
		//..
		//defaultValue = [parameters objectAtIndex:2];
		for(i = 0; i< [directions count]; i++){
			NSArray *crayon = [[directions objectAtIndex:i] componentsSeparatedByString:@"#"];
			NSString *directionId = [crayon objectAtIndex:0];			
			if ([directionId isEqualToString:defaultValue]) {
				[directionField selectRow:i inComponent:0 animated:NO];
				break;
			}
		}
	    //...
		//defaultValue = [parameters objectAtIndex:3];
		for(i = 0; i< [types count]; i++){
			NSArray *crayon = [[types objectAtIndex:i] componentsSeparatedByString:@"#"];
			NSString *typeId = [crayon objectAtIndex:0];			
			if ([typeId isEqualToString:defaultValue]) {
				[typeField selectRow:i inComponent:0 animated:NO];
				break;
			}
		}
	//}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
	[theTextField resignFirstResponder];
	return YES;
}


-(NSInteger) numberOfComponentsInPickerField:(UIComboBox*)pickerField {
	switch(pickerField.tag) {
        case STATUS_FIELD:
            return 1;
            break;            
        case DIRECT_FIELD:
            return 1;
            break;
        case TYPE_FIELD:
            return 1; 
            break;     
        default:
            return -1;
    }    
}

-(NSInteger) pickerField:(UIComboBox*)pickerField numberOfRowsInComponent:(NSInteger)component{
	
	switch(pickerField.tag) {
        case STATUS_FIELD:
            return [states count];
            break;			
        case DIRECT_FIELD:
            return [directions count];
            break;  
		case TYPE_FIELD:
            return [types count];
            break;	
        default:
            return 0;
    }	
}

-(NSString *) pickerField:(UIComboBox *)pickerField titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == -1) return nil;
	switch(pickerField.tag) {
        case STATUS_FIELD:
			if([states count]){			
				NSArray *crayon = [[states objectAtIndex:row] componentsSeparatedByString:@"#"];
				return [crayon objectAtIndex:1];
			}else
				return nil;
            break;            
        case DIRECT_FIELD:			
			if([directions count]){
				NSArray *crayon = [[directions objectAtIndex:row] componentsSeparatedByString:@"#"];
				return [crayon objectAtIndex:1];				
			}else
				return nil;
            break;    
		case TYPE_FIELD:
			if([types count]){	
				NSArray *crayon = [[types objectAtIndex:row] componentsSeparatedByString:@"#"];
				return [crayon objectAtIndex:1];			
			}else
				return nil;
            break; 	
        default:
            return nil;
    }	
}

- (void)selectedRowChange:(UIComboBox*)pickerField Row:(NSInteger)row inComponent:(NSInteger)component{
	if(row == -1) return;
	switch(pickerField.tag) {
        case STATUS_FIELD:
			if([states count]){			
				//NSArray *crayon = [[states objectAtIndex:row] componentsSeparatedByString:@"#"];
				//return [crayon objectAtIndex:1];
			}
            break;            
        case DIRECT_FIELD:			
			if([directions count]){
				NSString *currentDirection = self.directionField.text;
				NSArray *crayon = [[directions objectAtIndex:row] componentsSeparatedByString:@"#"];
				NSString *selectedValue = [crayon objectAtIndex:1];
				NSLog(@"selectedValue:%@",selectedValue);
				if([currentDirection isEqualToString:selectedValue]) return;
												
				BOOL find = FALSE;
				NSString *DirectionId = @"";
				for(int i = 0; i< [directions count]; i++){
					NSArray *crayon2 = [[directions objectAtIndex:i] componentsSeparatedByString:@"#"];
					NSString *directionValue = [crayon2 objectAtIndex:1];
					if ([directionValue isEqualToString:selectedValue]) {
						DirectionId = [crayon2 objectAtIndex:0];
						find = TRUE;
						break;
					}
				}
				if(find){
				  AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
				  NSString *hashCode = appDelegate.hashCode;
				  [webservice wsListDocumentTypes:hashCode DocumentID:DirectionId];
				}
			}				
            break;    
		case TYPE_FIELD:
			//if([types count]){	
			//	NSArray *crayon = [[types objectAtIndex:row] componentsSeparatedByString:@"#"];
			//	return [crayon objectAtIndex:1];			
			//}				
            break; 	
        default:
             break; 
    }	
}

- (void)clearManagedObjectsWithPredicate{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Document" 
											  inManagedObjectContext:appDelegate.managedObjectContext];
	[request setEntity:entity];
	NSString *iCategory = SearchDocument;
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",iCategory];	
	[request setPredicate:predicate];
	NSArray *objects = [appDelegate.managedObjectContext executeFetchRequest:request error:NULL];
	for (NSManagedObject *object in objects) {
		[appDelegate.managedObjectContext deleteObject:object];
	}	
}

- (IBAction)doSearch:(id)sender
{
    searchButton.enabled = FALSE;
	searchIndicator.hidden = FALSE;
	[searchIndicator startAnimating];
	
	int i = 0;
	NSString *state = self.stateField.text;
	/*NSString *stateId = @"";
	for( i = 0; i< [states count]; i++){
		NSDictionary *recordDict = [[states objectAtIndex:i] objectForKey:@"WorkFlowState"];
		NSDictionary *WorkflowLabel = [recordDict objectForKey:@"WorkflowLabel"];
		if ([state isEqualToString:[WorkflowLabel objectForKey:@"value"]]) {
			NSDictionary *IDWorkflowState = [recordDict objectForKey:@"IDWorkflowState"];
			stateId = [IDWorkflowState objectForKey:@"value"];
			break;
		}
	}*/
			
	NSString *direction = self.directionField.text;
	NSString *directionId = @"";
	for( i = 0; i< [directions count]; i++){
		NSArray *crayon = [[directions objectAtIndex:i] componentsSeparatedByString:@"#"];
		if ([direction isEqualToString:[crayon objectAtIndex:1]]) {
			directionId = [crayon objectAtIndex:0];
			break;
		}
	}
		
	NSString *type = self.typeField.text;
	NSString *typeId = @"";
	for( i = 0; i< [types count]; i++){
		NSArray *crayon = [[types objectAtIndex:i] componentsSeparatedByString:@"#"];
		if ([type isEqualToString:[crayon objectAtIndex:1]]) {
			typeId = [crayon objectAtIndex:0];
			break;
		}
	}
	
	//-----------------------------------------------------------------------------------------
	//NSArray *parameters =
	//    [[NSArray alloc] initWithObjects:self.codeField.text, 
	//	  stateId, directionId, typeId, self.entryField.text, nil];
	NSArray *parameters =  [[NSArray alloc] initWithObjects:self.codeField.text, 
	      state, directionId, typeId, self.entryField.text, nil];
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	// store the search parameters...
	//[appDelegate setSearchParameters:parameters];	
	
	appDelegate.searchParameters = [parameters copy];
	
	//NSString *currentView = appDelegate.currentView;
	//ToDo
	//if ([currentView isEqualToString: @"SearchDocumentView"]){
	//}else{
	//	[appDelegate clearCache];	
	//}
	[appDelegate clearCache];
	[self clearManagedObjectsWithPredicate];
	
	[appDelegate setCurrentView:@"SearchDocumentView"];	
	
	if(!targetViewController){				
		targetViewController = [[NSClassFromString(@"DocListViewController") alloc]
								initWithNibName:@"DocListViewController" bundle:nil];
		targetViewController.title = @"Search Results";
	}
	
	[targetViewController setParameters:parameters];
	[parameters release];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
							   style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release]; 	
	
	[self.navigationController pushViewController:targetViewController animated:YES];
	//[targetViewController release];
	
}


- (void) didOperationCompleted:(NSDictionary *)dict
{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];	
	
	if ([operation isEqualToString:@"WorkFlowState"]) {

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			for(i = 0; i < nResult; i++){

				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"WorkFlowState"];
				NSLog(@"WorkFlowState:%@",recordDict);
			}
		}else{			
			//[appDelegate messageBox:@"ListStateResult Operation failure" Error:nil];
		}		
	}else if ([operation isEqualToString:@"ListDirectionResult"]) {
		if([webservice getRecordCount]){
			NSInteger i = 0, nResult = [webservice getRecordCount];
			for(i = 0; i < nResult; i++){
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"ListDirectionResult"];
				NSLog(@"ListDirectionResult:%@",recordDict);
			}
		}else{			
			//[appDelegate messageBox:@"ListDirectionResult Operation failure" Error:nil];
		}		
	}else if ([operation isEqualToString:@"GDDocumentType"]) {

		if([recordStack count]){
			//typesArray = [[webservice getRecordLists] copy];	

			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			//add a default blank value
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){
	
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"GDDocumentType"];
				NSLog(@"recordDict:%@",recordDict);
				NSDictionary *IDGDDocumentType = [recordDict objectForKey:@"IDGDDocumentType"];
				NSDictionary *GDDocumentType = [recordDict objectForKey:@"GDDocumentType"];				
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDGDDocumentType objectForKey:@"value"],
								   [GDDocumentType objectForKey:@"value"]];
				[tempArray addObject:value];			      
			}
			AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
			if(appDelegate.typesArray != nil)
				[appDelegate.typesArray release];
			appDelegate.typesArray = [tempArray copy];
			
			if(types != nil) [types release];
			types = [[appDelegate getTypes] copy];
			[self.typeField refreshPickerView];
			
			[tempArray release];
		}else{
			//NSLog(@"GDDocumentType Operation failure");
		}
	}	
		
	searchButton.enabled = TRUE;
	[searchIndicator stopAnimating];
	searchIndicator.hidden = TRUE;
}	

- (void)didOperationError:(NSError*)error
{
    searchButton.enabled = TRUE;
	[searchIndicator stopAnimating];
	searchIndicator.hidden = TRUE;
	
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: [error localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	
	
	
}



@end
