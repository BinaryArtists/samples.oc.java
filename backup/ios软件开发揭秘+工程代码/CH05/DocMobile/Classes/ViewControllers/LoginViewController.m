//
//  LoginViewController.m
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "UIComboBox.h"
#import "AppDelegate.h"
#import "RSA.h"
#import "NSData+Base64.h"

#define DOMAIN_FIELD 2000
#define TEAM_FIELD   2001

@interface LoginViewController ()
- (id)infoValueForKey:(NSString *)key;
@end

@implementation LoginViewController

@synthesize domainsField, usernameText, passwordText;
@synthesize loginButton, navigationBar, activityIndicator;
@synthesize webservice;

extern NSInteger myLoginSuccess;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    self.title = NSLocalizedString(@"WebDoc Mobile", @"");	
	webservice = [WebDocWebService instance];	
	webservice.delegate = self;
	nInitCount = 0;
	
	return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];	
}

- (void)dealloc{
	[domains release];
	[webservice release];
	[activityIndicator release];
	[super dealloc];	
}


- (void)viewDidLoad{
	activityIndicator.hidden = TRUE;	
	self.view.backgroundColor = [UIColor whiteColor];	
	loginButton.tintColor = [UIColor darkGrayColor];	

	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	domains = [[appDelegate getDomains] copy];
	domainsField.formatString = @"%@ %@ %@";	
	
    [self setNavigatinBarStyle:DEFAULT_STATUS_BAR_STYLE];
}

- (void)viewDidUnload{
	domainsField = nil;
	loginButton = nil;
	activityIndicator = nil;
	navigationBar = nil;
}

- (id)infoValueForKey:(NSString *)key{
    // fetch objects from our bundle based on keys in our Info.plist
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key] ? : [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark UIComboBox
#pragma mark - 
// --------------------------------------------------
-(NSInteger) numberOfComponentsInPickerField:(UIComboBox*)pickerField {
	switch(pickerField.tag) {
        case DOMAIN_FIELD:
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
        case DOMAIN_FIELD:
            return [domains count];
            break;	          
        default:
            return 0;
    }	
}

-(NSString *) pickerField:(UIComboBox *)pickerField titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row == -1) return nil;
	switch(pickerField.tag) {
        case DOMAIN_FIELD:
			if([domains count]){
				NSDictionary *recordDict = [[domains objectAtIndex:row] objectForKey:@"Domain"];
				NSDictionary *DomainName = [recordDict objectForKey:@"Domain"];
				return [DomainName objectForKey:@"value"];					
			}else
			   return nil;
            break;            
        default:
            return nil;
    }	
}

- (void)selectedRowChange:(UIComboBox*)pickerField Row:(NSInteger)row inComponent:(NSInteger)component{
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField{
	[theTextField resignFirstResponder];
	return YES;
}

- (IBAction)doLogin:(id)sender{		
	[self.domainsField pickerViewHiddenIt:YES];	
	activityIndicator.hidden = FALSE;	
	loginButton.enabled = FALSE;
	loginButton.userInteractionEnabled = NO;
	[activityIndicator startAnimating];
	 
#if NETWORK	
	 #if ALWAYS_LOGIN			
		[activityIndicator stopAnimating];
		[self showMainMenu];
	 #else
	    //[webservice wsUserLogin:hashCode userName: self.usernameText.text 
	    //			   passWord:self.passwordText.text
	    //			 domainName:self.domainsField.text];
	
				
	    NSString* userText = self.usernameText.text;
	    NSString* passText = self.passwordText.text;
	    NSString* domainText = self.domainsField.text;
		
	
	    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	    NSString *pubkey = appDelegate.publicKey;
	    NSLog(@"doLogin, pubkey: %@",pubkey);	
		SimpleCrypto *crypto = [[SimpleCrypto alloc] init];
	
	    NSString* userNameEncrypted = [crypto encrypt_string:userText  PublicKey:pubkey];	
	    NSString* passwordEncrypted = [crypto encrypt_string:passText PublicKey:pubkey];
	    NSString* domainEncrypted = [crypto encrypt_string:domainText PublicKey:pubkey];
			
	    NSString *hashCode = appDelegate.hashCode;
	    [webservice wsUserLogin:hashCode userName: userNameEncrypted 
	   			   passWord:passwordEncrypted
	   			 domainName:domainEncrypted]; 	
	     [crypto release];	
			
      #endif
#else		
	[activityIndicator stopAnimating];
	[self showMainMenu];
#endif
	
}

- (void)showMainMenu{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate setLoginResult:1];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	[self release];	
}

- (void) didOperationCompleted:(NSDictionary *)dict
{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *hashCode = appDelegate.hashCode;
	if ([operation isEqualToString:@"LoginUserResult"]) {	
		BOOL loginFail = FALSE;

		if([recordStack count]){

			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"LoginUserResult"];
			NSLog(@"LoginUserResult: %@",recordDict);			
		    NSLog(@"LoginUser Value: %@",[recordDict objectForKey:@"value"]);
			NSString *result = [recordDict objectForKey:@"value"];
			//[appDelegate setLoginResult:1];
			//[self showMainMenu];
			if([result isEqualToString:@"true"]){
			    nInitCount++;
				[appDelegate setLoginResult:1];
			    [webservice wsListDirections:hashCode];
				
				[webservice wsListMyTeams:hashCode];
				[webservice wsListWorkflowStates:hashCode];				
				 NSString *intBookID = @"0";
				[webservice wsListDocumentTypes:hashCode DocumentID:intBookID];	
			}else{
				loginFail = TRUE;
				//[appDelegate messageBox:@"Login failure" Error:nil];
				#if !ALWAYS_LOGIN
					[appDelegate messageBox:@"Login failure" Error:nil];
				#endif
			}
		}else{
			loginFail = TRUE;
			[appDelegate setLoginResult:0];
			//[appDelegate messageBox:@"Login Operation failure!" Error:nil];			
			#if !ALWAYS_LOGIN
				[appDelegate messageBox:@"Login failure" Error:nil];
			#endif			
		}	
		
		#if ALWAYS_LOGIN
			[appDelegate setLoginResult:1];
			[self showMainMenu];
		#endif
		//nInitCount++;
		//[webservice wsListDirections:hashCode];	
		
		if(loginFail){
			loginButton.enabled = TRUE;
			loginButton.userInteractionEnabled = YES;
			activityIndicator.hidden = TRUE;
			[activityIndicator stopAnimating];
		}
		
	}else if ([operation isEqualToString:@"GDBook"]) {
		nInitCount++;

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			//add a default blank value
			[tempArray addObject:@"0#"];			
			for(i = 0; i < nResult; i++){

				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"GDBook"];
				NSDictionary *IDBook = [recordDict objectForKey:@"IDBook"];
				NSDictionary *GDBook = [recordDict objectForKey:@"GDBook"];				
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDBook objectForKey:@"value"],
								   [GDBook objectForKey:@"value"]];
				[tempArray addObject:value];			      
			}
			appDelegate.directionArray = [tempArray copy];
			[tempArray release];
		}else{
			//NSLog(@"ListDirection Operation failure");
		}	
		
//		[webservice wsListMyTeams:hashCode];
	}
	else if ([operation isEqualToString:@"Team"]) {
		nInitCount++;

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			for(i = 0; i< nResult; i++){

				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"Team"];
				NSLog(@"Team:%@",recordDict);
			}
			appDelegate.teamsArray = [[webservice getRecordLists] copy];
		}else{
			//NSLog(@"ListMyTeams Operation failure");
		}	
//		[webservice wsListWorkflowStates:hashCode];
	}
	else if ([operation isEqualToString:@"WorkFlowState"]) {
		nInitCount++;

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			//add a default blank value
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){

				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"WorkFlowState"];
				NSDictionary *IDWorkflowState = [recordDict objectForKey:@"IDWorkflowState"];
				NSDictionary *WorkflowLabel = [recordDict objectForKey:@"WorkflowLabel"];				
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDWorkflowState objectForKey:@"value"],
								   [WorkflowLabel objectForKey:@"value"]];
				[tempArray addObject:value];			      
			}
			appDelegate.workflowStateArray = [tempArray copy];
			[tempArray release];
		}else{
			//NSLog(@"ListWorkFlowState Operation failure");
		}
		//
//		NSString *intBookID = @"0";
//		[webservice wsListDocumentTypes:hashCode DocumentID:intBookID];	
	}
	else if ([operation isEqualToString:@"GDDocumentType"]) {
		nInitCount++;

		if([recordStack count]){

			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			//add a default blank value
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){
	
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"GDDocumentType"];
				NSDictionary *IDGDDocumentType = [recordDict objectForKey:@"IDGDDocumentType"];
				NSDictionary *GDDocumentType = [recordDict objectForKey:@"GDDocumentType"];				
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDGDDocumentType objectForKey:@"value"],
								   [GDDocumentType objectForKey:@"value"]];
				[tempArray addObject:value];			      
			}
			appDelegate.typesArray = [tempArray copy];
			[tempArray release];
		}else{
			//NSLog(@"GDDocumentType Operation failure");
		}
	}
		
	if(nInitCount > 4){
		loginButton.enabled = TRUE;
		loginButton.userInteractionEnabled = YES;
		activityIndicator.hidden = TRUE;
		[activityIndicator stopAnimating];
		
	   [appDelegate setLoginResult:1];
	   [self showMainMenu];
	}
}	

- (void)didOperationError:(NSError*)error
{
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate messageBox:@"" Error:error];
	
	loginButton.enabled = TRUE;
	loginButton.userInteractionEnabled = YES;
	activityIndicator.hidden = TRUE;
	[activityIndicator stopAnimating];

#if ALWAYS_LOGIN
	[appDelegate setLoginResult:1];
	[self showMainMenu];
#endif
	
}

//
- (void)setNavigatinBarStyle:(NSInteger)style
{
    // Change the navigation bar style, also make the status bar match with it
	switch (style)
	{
		case STATUS_BAR_STYLE_DEFAULT:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
			self.navigationBar.barStyle = UIBarStyleDefault;
			break;
		}
		case STATUS_BAR_STYLE_BLACKOQAUE:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
			self.navigationBar.barStyle = UIBarStyleBlackOpaque;
			break;
		}
		case STATUS_BAR_STYLE_BLACKTRANSLUCENT:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
			self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			break;
		}
	}
}


@end
