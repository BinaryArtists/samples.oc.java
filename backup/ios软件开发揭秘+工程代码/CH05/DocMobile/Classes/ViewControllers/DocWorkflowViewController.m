//
//  DocWorkflowViewController.m
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "DocWorkflowViewController.h"
#import "UIComboBox.h"
#import "AppDelegate.h"
#import "DocumentDetailViewController.h"
#import "Document.h"

#if WITH_SEARCHVIEWCONTROLLER
#import "SearchViewController.h"
#endif

#define KEYBOARD_HEIGHT 240 
#define TOOLBAR_HEIGHT  30
#define MAX_TEXT_LENGTH 29

#define STATE_FIELD     4000
#define TEAM_FIELD      4001
#define USER_FIELD      4002

@interface DocWorkflowViewController ()
- (id)infoValueForKey:(NSString *)key;
@end

@implementation DocWorkflowViewController

@synthesize webservice, documentId;
@synthesize managingViewController, activityIndicator;  
@synthesize uiToolbar, states, teams, users;
@synthesize stateField, teamField, userField, commentField;

- (void)setDocumentId:(NSString *)doc{
	documentId = doc;
}

- (id)initWithParentViewController:(UIViewController *)aViewController {
    if (self = [super initWithNibName:@"DocWorkflowViewController" bundle:nil]) {
        self.managingViewController = aViewController;			
        self.title = @"Workflow";		
    }
    return self;
}

- (void)viewDidLoad {
	
	((DocumentDetailViewController*)managingViewController).delegate = self;
		
	// every time fetch new data.
	states = [[NSMutableArray alloc] init];
	teams = [[NSMutableArray alloc] init];
	users = [[NSMutableArray alloc] init];
	
#if WITH_SEARCHVIEWCONTROLLER
	stateField.delegate = self;
	teamField.delegate = self;	
	userField.delegate = self;
#else	
	stateField.formatString = @"%@ %@ %@";	
	teamField.formatString = @"%@ %@ %@";
	userField.formatString = @"%@ %@ %@";
#endif	
		
	firstComment = TRUE;
    [self.commentField setEditable: NO];
	self.commentField.layer.borderWidth = 1;	
	self.commentField.layer.cornerRadius = 8; //This is for achieving the rounded corner.	
	self.commentField.layer.borderColor = [[UIColor grayColor] CGColor];
	self.commentField.scrollEnabled = YES;
	//self.commentField.textColor = [UIColor colorWithWhite:1 alpha:1];
	//self.commentField.backgroundColor = [UIColor clearColor];
	//self.commentField.textAlignment = UITextAlignmentLeft;
	//self.commentField.font = [UIFont systemFontOfSize:13];		
		
}

- (void)viewDidUnload {
   	stateField  = nil;
	teamField  = nil;
	userField  = nil;
	commentField  = nil;
	uiToolbar  = nil;	
    [super viewDidUnload];
}


- (void)dealloc {
	[states release];
	[teams release];
	[users release];
	[webservice release];
    self.managingViewController = nil;
    [super dealloc];	
}

- (id)infoValueForKey:(NSString *)key
{
    // fetch objects from our bundle based on keys in our Info.plist
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key] ? : [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

- (NSString *)formatLongTextWithDotDot:(NSString *)inputString MaxLength:(int)len{
	if ([inputString length] > len){
		int i = len - 3;
	    NSString *tempString = [NSString stringWithFormat:@"%@...",[inputString substringToIndex:i]];
		return tempString;
	}
	return inputString;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#if !WITH_SEARCHVIEWCONTROLLER 
// --------------------------------------------------
-(NSInteger) numberOfComponentsInPickerField:(UIComboBox*)pickerField {
	switch(pickerField.tag) {
        case STATE_FIELD:
            return 1;
            break;            
        case TEAM_FIELD:
            return 1;
            break;            
        default:
            return -1;
    }    
}

-(NSInteger) pickerField:(UIComboBox*)pickerField numberOfRowsInComponent:(NSInteger)component{
	switch(pickerField.tag) {
        case STATE_FIELD:
            return [states count];
            break;			
		case TEAM_FIELD:
			return [teams count];           
        default:
            return 0;
    }	
}

-(NSString *) pickerField:(UIComboBox *)pickerField titleForRow:(NSInteger)row forComponent:(NSInteger)component{
 	
	if(row == -1)		
		return nil;
	switch(pickerField.tag) {
        case STATE_FIELD:
			if([states count]){		
				NSDictionary *recordDict = [[states objectAtIndex:row] objectForKey:@"WorkFlowState"];
				NSDictionary *WorkflowLabel = [recordDict objectForKey:@"WorkflowLabel"];
				return [WorkflowLabel objectForKey:@"value"];	
			}else
				return nil;
            break;            
		case TEAM_FIELD:				
			if([teams count]){	
				NSDictionary *recordDict = [[teams objectAtIndex:row] objectForKey:@"Team"];
				NSDictionary *Team = [recordDict objectForKey:@"TeamName"];
				return [Team objectForKey:@"value"];				
			}else
				return nil;            
        default:
            return nil;
    }	
}

#endif //WITH_SEARCHVIEWCONTROLLER

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
	[theTextField resignFirstResponder];
	return YES;	
}

- (void)refreshStateList{
	
	//start animating... 
	bDataFetching = TRUE;
	activityIndicator.hidden = FALSE;
	[activityIndicator startAnimating];
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *hashCode = appDelegate.hashCode;
	[webservice wsListWorkflowStatesTo:hashCode DocumentID:documentId];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	if(webservice == nil){
		savedState  = 0;
		savedTeam = 0;
	    webservice = [WebDocWebService instance];
		webservice.delegate = self;		
	}
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if(appDelegate.dictWorkflow != nil){
	    states = appDelegate.dictWorkflow;	
	}else{
		///start animating... 
		bDataFetching = TRUE;
		activityIndicator.hidden = FALSE;
		[activityIndicator startAnimating];
		
		NSString *hashCode = appDelegate.hashCode;
		[webservice wsListWorkflowStatesTo:hashCode DocumentID:documentId];
	}
		
}

- (void)viewDidAppear:(BOOL)animated
{
#if !WITH_SEARCHVIEWCONTROLLER	
	#if !DEBUG	
		int i = 0;
	
	    Document *doc = (DocumentDetailViewController *)managingViewController.document;
	    NSString *defaultValue = doc.documentState;
				
		for(i = 0; i< [states count]; i++){
			NSDictionary *recordDict = [[states objectAtIndex:i] objectForKey:@"WorkflowState"];
			NSDictionary *WorkflowLabel = [recordDict objectForKey:@"WorkflowLabel"];
			NSString *state  = [WorkflowLabel objectForKey:@"value"];
			if ([state isEqualToString:defaultValue]) {
				[stateField selectRow:i inComponent:0 animated:NO];
				break;
			}
		}	
		//...
		defaultValue = @"My Team Name";
		for(i = 0; i< [teams count]; i++){
			NSDictionary *recordDict = [[teams objectAtIndex:i] objectForKey:@"Team"];
			NSDictionary *Team = [recordDict objectForKey:@"TeamName"];
			NSString *team  = [Team objectForKey:@"value"];
			if ([team isEqualToString:defaultValue]) {
				[teamField selectRow:i inComponent:0 animated:NO];
				break;
			}
		}	
	#endif	
#endif
}


- (void)viewWillDisappear:(BOOL)animated {
	commentField.opaque = NO;
	commentField.backgroundColor = [UIColor clearColor];
	commentField.font = [UIFont fontWithName:@"Helvetica" size:14];
	commentField.userInteractionEnabled = NO;
	
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

#if !WITH_SEARCHVIEWCONTROLLER
    [self.stateField pickerViewHiddenIt:YES];
	[self.teamField pickerViewHiddenIt:YES];	
#endif	
    	
}

- (void)SearchResultString:(NSString *)newValue{

    NSLog(@"newValue:%@",newValue);
	BOOL shouldRefresh = FALSE;
	if(currentTag == STATE_FIELD){
		NSArray *crayon0 = [newValue componentsSeparatedByString:@"#"];
		NSInteger no = [[crayon0 objectAtIndex:0] intValue];
		NSString *text = [crayon0 objectAtIndex:1];
		if(savedState != no){
			shouldRefresh = TRUE;
		}
		savedState = no;
		text = [self formatLongTextWithDotDot:text MaxLength:MAX_TEXT_LENGTH];				
		self.stateField.text = text;
		if(shouldRefresh){			
			[self refreshTeamList];
		}
				
	}else if(currentTag == TEAM_FIELD){
		NSArray *crayon0 = [newValue componentsSeparatedByString:@"#"];
		NSInteger no = [[crayon0 objectAtIndex:0] intValue];
		NSString *text = [crayon0 objectAtIndex:1];	
		if(savedTeam != no){
			shouldRefresh = TRUE;
		}	
		savedTeam = no;	
		NSLog(@"newValue,savedTeam:%d",savedTeam);
		text = [self formatLongTextWithDotDot:text MaxLength:MAX_TEXT_LENGTH];
		self.teamField.text = text;
		if(shouldRefresh){			
			[self refreshUserList];
		}		
	}else{
		NSArray *crayon = [newValue componentsSeparatedByString:@"#"];
		self.userField.text = [crayon objectAtIndex:1];
	}	
}


- (void)takeNewString:(NSString *)newValue{
	   commentField.text = newValue;	
}

- (UINavigationController *)navController{
	return self.managingViewController.navigationController;
}

- (UINavigationController *)NavigationController{
	return self.managingViewController.navigationController;
}


- (void)keyboardReturnEvent:(NSInteger)notification{
	switch(notification) {
        case STATE_FIELD:
			[stateField resignFirstResponder];
            break;            
        case TEAM_FIELD:
			[teamField resignFirstResponder];
            break;   
		case USER_FIELD:
			[userField resignFirstResponder];
            break; 
        default:
			return;
    } 
}

- (NSString*)findStateId:(NSString*)state{
	int i = 0;
	for(i = 0; i< [states count];i++){
		NSString *item =  [states objectAtIndex:i];
		NSArray *crayon = [item componentsSeparatedByString:@"#"];
		if([state isEqualToString:[crayon objectAtIndex:1]]){
			NSString *stateId = [crayon objectAtIndex:0];
			return stateId;			
		}
	}
	return nil;
}

- (NSString*)findTeamId:(NSString*)team{
	int i = 0;
	for(i = 0; i< [teams count];i++){
		NSString *item =  [teams objectAtIndex:i];
		NSArray *crayon = [item componentsSeparatedByString:@"#"];
		if([team isEqualToString:[crayon objectAtIndex:1]]){
			NSString *teamId = [crayon objectAtIndex:0];
			return teamId;
			break;
		}
	}
	return nil;
}

- (NSString*)findUserId:(NSString*)user{
	int i = 0;
	for(i = 0; i< [users count];i++){
		NSString *item =  [users objectAtIndex:i];
		NSArray *crayon = [item componentsSeparatedByString:@"#"];
		if([user isEqualToString:[crayon objectAtIndex:1]]){
			NSString *userId = [crayon objectAtIndex:0];
			return userId;
			break;
		}
	}
	return nil;
}

- (void)refreshTeamList{
	//NSString *stateId = [self findStateId:stateField.text];
	NSString *stateId = [NSString stringWithFormat:@"%d",savedState];
	//if(stateId != nil){
		//TODO
		NSString *group = @""; //????;	    
			
		AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		NSString *hashCode = appDelegate.hashCode;
		
		//start animating... 
		bDataFetching = TRUE;
		activityIndicator.hidden = FALSE;
		[activityIndicator startAnimating];
		NSLog(@"refreshTeamList:%@",stateId);
		[webservice wsListMyDocumentTeams:hashCode StateTo:stateId Group:group];
	//}
}

- (void)refreshUserList{	
	//NSString *stateId = [self findStateId:stateField.text];
	NSString *stateId = [NSString stringWithFormat:@"%d",savedState];
	//if(stateId != nil){
		//TODO
		//team id is the ListWorkflowTeamTo value, otherwise is 0
		//NSString *teamId = [self findStateId:teamField.text];
		//teamId = (teamId == nil) ? @"0": teamId;	
        NSString *teamId = [NSString stringWithFormat:@"%d", savedTeam];		
	
		AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		NSString *hashCode = appDelegate.hashCode;
		
		//start animating... 
		bDataFetching = TRUE;
		activityIndicator.hidden = FALSE;
		[activityIndicator startAnimating];
	    NSLog(@"refreshUserList,savedTeam:%d",savedTeam);
		NSLog(@"***refreshUserList:%@",teamId);	
		[webservice wsListWorkflowUsers:hashCode StateTo:stateId Team:teamId];
	//}
}

- (void)comboxButtonTapped:(id)sender event:(id)event
{
	NSInteger tag = ((UITextField *)sender).tag;
	currentTag = tag;
#if	DEBUG_SEARCH_VIEW
	SearchViewController *controller = [[SearchViewController alloc] 
										initWithStyle:UITableViewStyleGrouped];
	
	controller.delegate = self;	
	[self.managingViewController.navigationController pushViewController:controller animated:YES];
	[controller release];
#else
	if(tag == TEAM_FIELD ||tag == USER_FIELD) { 
		NSString *stateText = stateField.text;
		if([stateText length] == 0){
			UIAlertView *errorAlert = [[UIAlertView alloc]
									   initWithTitle: @"WebDoc Mobile"
									   message: @"please select a state first."
									   delegate:nil
									   cancelButtonTitle:@"OK"
									   otherButtonTitles:nil];
			[errorAlert show];
			[errorAlert release];
			return;
		}				
    }	
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if(tag == STATE_FIELD){
		if([states count] == 0){
			[self refreshStateList];
			[appDelegate messageBox:@"fetch data from server,please try again" Error:nil];
			return;
		}
	}	
	
	if(tag == STATE_FIELD){	
		if([states count] == 0) return;
		[appDelegate setSearchList:states];
	}else if(tag == TEAM_FIELD){
		if([teams count] == 0){
			[self refreshTeamList];
			return;
		}
		[appDelegate setSearchList:teams];
	}else if(tag == USER_FIELD){
		if([users count] == 0){
			[self refreshUserList];			
			return;
		}
		[appDelegate setSearchList:users];
	}
	
	//NSArray *countriesToLiveInArray = appDelegate.searchList;
	//if([countriesToLiveInArray count] > 0){
		//show search view.
		//SearchViewController *controller = [[SearchViewController alloc] 
		//									initWithStyle:UITableViewStyleGrouped];
		SearchViewController *controller = [[SearchViewController alloc] 
											initWithNibName:@"SearchViewController" bundle:nil];

		controller.delegate = self;	
		[self.managingViewController.navigationController pushViewController:controller animated:YES];
		[controller release];
	//}else{
	//	[appDelegate messageBox:@"fetch data from server,please try again" Error:nil];
	//}
	
#endif	
	
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

- (IBAction)addComment:(id)sender{

	LongTextFieldViewController *controller = 
	    [[LongTextFieldViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;	
	controller.isHistory = FALSE;
	if(firstComment){
		firstComment = FALSE;
	    controller.string = @"";
		commentField.text = @"";
	}else{
		controller.string = commentField.text;
	}
	[self.managingViewController.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)updateWorkflow:(NSString*)str{
	
	//TODO
	NSString *stateId = [self findStateId:stateField.text];
	stateId = (stateId == nil) ? @"0":stateId;
	
	NSString *teamId = [self findTeamId:teamField.text];
	teamId = (teamId == nil) ? @"0":teamId;
		
	NSString *userId = [self findUserId:userField.text];
	userId = (userId == nil) ? @"0":userId;
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *hashCode = appDelegate.hashCode;
	
	//start animating... 
	bDataFetching = TRUE;
	activityIndicator.hidden = FALSE;
	[activityIndicator startAnimating];
	
	appDelegate.reloadDetais = FALSE;
	[webservice wsDoWorkFlow:hashCode DocumentID:documentId 
        StateTo:stateId TeamTo:teamId UserTo:userId Comment:commentField.text];
	
}

- (void) didOperationCompleted:(NSDictionary *)dict
{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];		
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];		
	if ([operation isEqualToString:@"WorkFlowState"]) {	    

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			NSString *savedString = @"";
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){
	
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"WorkFlowState"];
				NSDictionary *IDWorkflowState = [recordDict objectForKey:@"IDWorkflowState"];
				NSDictionary *WorkflowLabel = [recordDict objectForKey:@"WorkflowLabel"];
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDWorkflowState objectForKey:@"value"],
								   [WorkflowLabel objectForKey:@"value"]];	
				if(i == 0){
					savedState  = [[IDWorkflowState objectForKey:@"value"] intValue];					
					savedString = [WorkflowLabel objectForKey:@"value"];
				}
				[tempArray addObject:value];						      
			}
			if(states != nil) [states release];
			states = [tempArray copy];
			if(appDelegate.dictWorkflow != nil)
				[appDelegate.dictWorkflow release];
			appDelegate.dictWorkflow = [tempArray copy];
			[appDelegate setSearchList:tempArray];
			[tempArray release];	
			
			if(nResult > 0){
				savedString = [self formatLongTextWithDotDot:savedString MaxLength:MAX_TEXT_LENGTH];				
			    stateField.text = savedString;
			}			
		}else{
			//[appDelegate messageBox:@"ListWorkFlowStateTo Operation failure" Error:nil];
		}				
	}else if ([operation isEqualToString:@"Team"]) {

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			NSString *savedString = @"";
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){

				  NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"Team"];
				  NSDictionary *IDTeam = [recordDict objectForKey:@"IDTeam"];
			      NSDictionary *TeamName = [recordDict objectForKey:@"TeamName"];
				  NSString *value = [NSString stringWithFormat: @"%@#%@", 
				       [IDTeam objectForKey:@"value"],[TeamName objectForKey:@"value"]];
				  if(i == 0){
					savedTeam  = [[IDTeam objectForKey:@"value"] intValue];
					savedString = [TeamName objectForKey:@"value"];
				  }
			      [tempArray addObject:value];			      
			 }
			 if(teams != nil) [teams release];
			 teams = [tempArray copy];
				
			//------
			[appDelegate setSearchList:tempArray];
			[tempArray release];	
			
			if(nResult > 0){
				savedString = [self formatLongTextWithDotDot:savedString MaxLength:MAX_TEXT_LENGTH];
				teamField.text = savedString;
			}
		}else{
			//[appDelegate messageBox:@"ListTeams Operation failure" Error:nil];
			NSMutableArray *tempArray = [[NSMutableArray alloc] init];
			if(teams != nil) [teams release];
			teams = [tempArray copy];
			[tempArray release];
			teamField.text = @"";
		}
	}else if ([operation isEqualToString:@"User"]) {

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			NSString *savedString = @"";
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){

				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"User"];
				NSDictionary *IDUser = [recordDict objectForKey:@"IDUser"];
				NSDictionary *UserFullName = [recordDict objectForKey:@"UserFullName"];
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDUser objectForKey:@"value"],
								   [UserFullName objectForKey:@"value"]];
				if(i == 0)
					savedString = [UserFullName objectForKey:@"value"];
				[tempArray addObject:value];			      
			}
			if(users != nil) [users release];
			users = [tempArray copy];
				
			[appDelegate setSearchList:tempArray];
			[tempArray release];
			
			if(nResult > 0){
				userField.text = savedString;
			}
		}else{			

			NSMutableArray *tempArray = [[NSMutableArray alloc] init];
			if(users != nil) [users release];
			users = [tempArray copy];
			[tempArray release];
			userField.text = @"";
		}
	}else if ([operation isEqualToString:@"FowardWkfResult"]) {
	
		if([recordStack count]){

			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"FowardWkfResult"];
			NSString *strResult = [recordDict objectForKey:@"value"];
			if ([strResult isEqualToString:@"true"]) {
				appDelegate.reloadDetais = TRUE;
				[appDelegate messageBox:@"update workflow ok!" Error:nil];
			}else{
				appDelegate.reloadDetais = FALSE;
				[appDelegate messageBox:@"update workflow failure!" Error:nil];
			}
		}
	}
	
	//stop animating... 
	bDataFetching = FALSE;
	activityIndicator.hidden = TRUE;
	[activityIndicator stopAnimating];
	
}	


- (void)didOperationError:(NSError*)error{
	activityIndicator.hidden = TRUE;
	[activityIndicator stopAnimating];
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate messageBox:@"" Error:error];
	
}


@end
