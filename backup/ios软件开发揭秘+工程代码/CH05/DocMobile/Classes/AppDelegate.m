//
//  WebDocAppDelegate.m
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import <Foundation/Foundation.h>
#import "SplashViewController.h"
#import "RSA.h"
#import "Reachability.h"
#import "RecordCache.h"

NSString *kFirstNameKey			= @"firstNameKey";
NSString *kLastNameKey			= @"lastNameKey";

@implementation AppDelegate

@synthesize navigationController, window;
@synthesize webservice,reloadDetais,reloadFiles,documentId,searchList;
@synthesize dictDetail, dictFiles, dictHistory, dictWorkflow;
@synthesize hashCode, publicKey,currentView,currentTitle;
@synthesize myCurrentPage, teamCurrentPage, searchCurrentPage, cacheStack, searchParameters;
@synthesize myTotalDocuments, myTeamTotalDocuments;
@synthesize typesArray, directionArray, workflowStateArray, teamsArray;
@synthesize myTotalPage, teamTotalPage, searchTotalPage;

#pragma mark -
#pragma mark Application lifecycle
- init {
    if ((self = [super init])) {
		myLoginSuccess = 0;
		currentView = @"MyDocumentView";
		hashCode = @"DevCode"; 
		myCurrentPage = 0;
		teamCurrentPage = 0;
		searchCurrentPage = 0;
		myTotalPage = 0;
		teamTotalPage = 0;
		searchTotalPage = 0;
		reloadDetais = FALSE;
		reloadFiles = FALSE;
    }
    return self;
}

- (void)setupByPreferences
{
	NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kFirstNameKey];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
				
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
		NSString *urlDefault = nil;
		NSString *actionDefault = nil;
		
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:kFirstNameKey])
			{
				urlDefault = defaultValue;
			}
			else if ([keyValueStr isEqualToString:kLastNameKey])
			{
				actionDefault = defaultValue;
			}			
		}
        
		// since no default values have been set (i.e. no preferences file created), create it here		
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     urlDefault, kFirstNameKey,
                                     actionDefault, kLastNameKey,                                     
                                     nil];
        
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// we're ready to go, so lastly set the key preference values
	webservice.serviceURL = [[NSUserDefaults standardUserDefaults] stringForKey:kFirstNameKey];
	webservice.actionURL = [[NSUserDefaults standardUserDefaults] stringForKey:kLastNameKey];
	
	NSLog(@"***baseURL:%@",webservice.serviceURL);
	NSLog(@"***actionURL:%@",webservice.actionURL);
	//[self messageBox:webservice.serviceURL Error:nil];
	//[self messageBox:webservice.actionURL Error:nil];	
	
}


- (void)defaultsChanged:(NSNotification *)notif
{
	NSLog(@"***defaultsChanged");
    [self setupByPreferences];    	
}


- (NSString *)getIPAddressForHost: (NSString *)baseURL{
	/*
	 NSRange iCheck = [baseURL rangeOfString :@"http://"];
	 if (iCheck.length > 0){		
	 }else{
	 return NULL;
	 }
	 NSString *tmpStr = [baseURL substringFromIndex:7];
	 NSRange iStart = [tmpStr rangeOfString :@"/"];
	 NSString *ip = tmpStr;
	 if (iStart.length > 0){	
	 ip = [tmpStr substringToIndex:iStart.location-1];
	 }
	 //	
	 struct hostent *host = gethostbyname([ip UTF8String]);
	 if (host == NULL) { 
	 return NULL;
	 }
	 struct in_addr **list = (struct in_addr **)host->h_addr_list; 
	 NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0])]; 
	 return addressString;	 
	*/
	return nil;
}

- (BOOL)isReachabilitable{
	// Check if the network is available, if not, show the hint and return.
	Reachability *reachability = [Reachability sharedReachability];
	NSString *ip = @"";//[self getIPAddressForHost: webservice.serviceURL];
	if(ip == NULL) return FALSE;
	reachability.address = ip;
	NSLog(@"address ==>%@",reachability.address);
	//NetworkStatus connectionStatus = [reachability internetConnectionStatus];
	NetworkStatus connectionStatus = [reachability remoteHostStatus];
	if( connectionStatus == NotReachable ){
		return FALSE;
	}else{
		return TRUE;
	}
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    

	webservice = [WebDocWebService instance];	
	webservice.delegate = self;		
		
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(defaultsChanged:)
												 name:NSUserDefaultsDidChangeNotification
											   object:nil];	
	[self setupByPreferences];	
	
	//-------------------------------------------------------------------	
	//	if([self isReachabilitable]){
	//	}else{
	//		NSString *message = [NSString stringWithFormat:@"network address %@ is not reachable",
	//							 webservice.serviceURL];
	//		[self messageBox:message Error:nil];
	//		return;
	//	}
	//-------------------------------------------------------------------
	
    searchParameters = [[NSArray alloc] init];
	domainsArray = [[NSMutableArray alloc] init];
	typesArray = [[NSMutableArray alloc] init];
	teamsArray = [[NSMutableArray alloc] init];
	directionArray = [[NSMutableArray alloc] init];
	workflowStateArray = [[NSMutableArray alloc] init];
	usersArray = [[NSMutableArray alloc] init];
	
	//[webservice wsInit];
	[webservice wsInit_OpenSSL];
	
	nInitCount = 0;
	netInitialized = NO;	
	
	NSString *viewControllerName = @"SplashViewController";
	splashController = [[NSClassFromString(viewControllerName) alloc]
						initWithNibName:viewControllerName bundle:nil];
	//[window addSubview:splashController.view];
	//[navigationController pushViewController:splashController animated:YES];
	//[window addSubview:navigationController.view];
	navigationController2 = [[UINavigationController alloc] initWithRootViewController:splashController];
	
	[window addSubview:navigationController.view];
	[window makeKeyAndVisible];	
	
}

#pragma mark -
#pragma mark API DEFINES
- (NSMutableArray *)getDomains{
	return domainsArray;
}

- (NSMutableArray *)getTeams{
	return teamsArray;		
}
- (NSMutableArray *)getTypes{
	return typesArray;
}

- (NSMutableArray *)getDirections{
	return directionArray;	
}

- (NSMutableArray *)getWorkflowStates{
	return workflowStateArray;		
}

- (void) setLoginResult:(NSInteger) result{
	myLoginSuccess = result;
}

- (NSInteger) getLoginResult{
	return myLoginSuccess;
}

- (void) clearCache{
	int i = 0;
	for(i = 0; i < [cacheStack count]; i++){
		NSDictionary* dict = [cacheStack objectAtIndex:i];
		if(dict != nil){
			[dict release];
			[cacheStack removeObjectAtIndex: i];  
		}  
	}
}

- (void)setSearchList:(NSMutableArray *)list{
	if(searchList != nil){
		[searchList release];
	}
	searchList = [[NSMutableArray alloc] init];
	searchList = [list copy];
}

- (void) addPageController:(NSArray*)controller
{
	int i = 0;	
	if(cacheStack == nil){
		cacheStack = [[NSMutableArray alloc] init];			
	}	
	for(i = [cacheStack count]-1; i > (MAX_CACHE_PAGES-2); i--){
		NSDictionary* dict = [cacheStack objectAtIndex:i];
		if(dict != nil){
			[dict release];
			[cacheStack removeObjectAtIndex: i];  
		}  
	}
	i = [cacheStack count];
	NSString *myPagekey = [NSString stringWithFormat:@"Page%d",i];
	NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];	
	[myDict setValue: myPagekey forKey: @"PageKey"];
	[myDict setValue: [controller copy] forKey: @"Controllers"];	
	
	[cacheStack insertObject:myDict atIndex:i];
	
}

- (NSMutableArray*) getPageController:(NSInteger)currentPage
{
	int i = 0;		
	NSInteger idx = currentPage-1;
	if(idx < 0)
		idx = 0;
	NSMutableArray *controller = nil;
	NSString *myPagekey = [NSString stringWithFormat:@"Page%i",idx];	
	for(i = 0; i < [cacheStack count]; i++){
		NSDictionary* pageDict = [cacheStack objectAtIndex:i];
		NSString *pageKey = [pageDict objectForKey:@"PageKey"];			
		if ([pageKey isEqualToString:myPagekey]){			
			controller = [pageDict objectForKey:@"Controllers"];		   
			break;
		}
	}	
	return controller;
}

- (NSString *)dbHelper:(NSDictionary*)row Key:(NSString *)key{
	NSDictionary *dict = (NSDictionary*)[row objectForKey:key];
	return [dict objectForKey:@"value"];
}

- (void)listDocumentTypes{
	//TODO
	
	NSString *intBookID = @"0";
	[webservice wsListDocumentTypes:hashCode DocumentID:intBookID];
}

- (void) didOperationCompleted:(NSDictionary *)dict
{
	int i = 0;
	
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	
	/*
	 if ([operation isEqualToString:@"InitResult"]) {		
	 if([webservice getRecordCount]){
	 NSDictionary *recordDict = [webservice getRecordAtIndex:0];
	 //NSLog(@"InitResult recordDict:%@",recordDict);			
	 NSLog(@"InitResult: sHashCode=%@,Modulus=%@,Exponent=%@",
	 [self dbHelper:recordDict Key:@"HashCode"],
	 [self dbHelper:recordDict Key:@"Modulus"],
	 [self dbHelper:recordDict Key:@"Exponent"]);
	 
	 //now list domains ...	
	 //hashCode = @"DevHash";			
	 hashCode = [self dbHelper:recordDict Key:@"HashCode"]; 			
	 //publicKey = [self dbHelper:recordDict Key:@"PublicKey"];
	 
	 //NSLog(@"InitResult hashCode:%@",hashCode);
	 //NSLog(@"InitResult publicKey:%@",publicKey);
	 
	 //[self setHashCode:myHashCode];	
	 //[webservice wsListDomains:hashCode];	
	 }else{
	 //NSLog(@"Init Operation failure");
	 }
	 
	 [webservice wsInit_OpenSSL];
	 
	 }else*/
	
	if ([operation isEqualToString:@"Init_OpenSLLResult"]) {
		nInitCount++;
		if([recordStack count] > 0){
			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"Init_OpenSLLResult"];			
			//NSLog(@"Init_OpenSLL recordDict:%@",recordDict);
			hashCode =  [[recordDict objectForKey:@"HashCode"] objectForKey:@"value"];
			publicKey = [[recordDict objectForKey:@"PublicKey"] objectForKey:@"value"];
			
			NSLog(@"Init_OpenSLL hashCode:%@", hashCode);
			NSLog(@"Init_OpenSLL publicKey:%@", publicKey);
			
		}else{
			NSLog(@"Init_OpenSLL Operation failure");
		}	
		
		[webservice wsListDomains:hashCode];		
		
	}else if ([operation isEqualToString:@"Domain"]) {
		nInitCount++;
		if([recordStack count] > 0){
			NSInteger nResult = [recordStack count];
			for(i = 0; i< nResult; i++){
				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"Domain"];
				NSLog(@"Domain:%@",recordDict);
			}
			domainsArray = [recordStack copy];
		}else{
			//NSLog(@"ListDomain Operation failure");
		}		
		//[webservice wsListDirections:hashCode];		
	}
	else if ([operation isEqualToString:@"GDBook"]) {
		nInitCount++;
		if([recordStack count] > 0){
			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			//add a default blank value
			[tempArray addObject:@"0#"];			
			for(i = 0; i < nResult; i++){
				NSDictionary *recordDict = [recordStack objectAtIndex:i];
				NSDictionary *IDBook = [recordDict objectForKey:@"IDBook"];
				NSDictionary *GDBook = [recordDict objectForKey:@"GDBook"];				
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDBook objectForKey:@"value"],
								   [GDBook objectForKey:@"value"]];
				[tempArray addObject:value];			      
			}
			directionArray = [tempArray copy];
			[tempArray release];
		}else{
			//NSLog(@"ListDirection Operation failure");
		}	
		
		[webservice wsListMyTeams:hashCode];
	}
	else if ([operation isEqualToString:@"Team"]) {
		nInitCount++;
		if([recordStack count] > 0){
			NSInteger nResult = [recordStack count];
			for(i = 0; i< nResult; i++){
				NSDictionary *recordDict = [recordStack objectAtIndex:i];
				NSLog(@"Team:%@",recordDict);
			}
			teamsArray = [[webservice getRecordLists] copy];
		}else{
			//NSLog(@"ListMyTeams Operation failure");
		}	
		[webservice wsListWorkflowStates:hashCode];
	}
	else if ([operation isEqualToString:@"WorkFlowState"]) {
		nInitCount++;
		if([recordStack count] > 0){
			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			//add a default blank value
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){
				NSDictionary *recordDict = [recordStack objectAtIndex:i];
				NSDictionary *IDWorkflowState = [recordDict objectForKey:@"IDWorkflowState"];
				NSDictionary *WorkflowLabel = [recordDict objectForKey:@"WorkflowLabel"];				
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDWorkflowState objectForKey:@"value"],
								   [WorkflowLabel objectForKey:@"value"]];
				[tempArray addObject:value];			      
			}
			workflowStateArray = [tempArray copy];
			[tempArray release];
		}else{
			//NSLog(@"ListWorkFlowState Operation failure");
		}
		//
		NSString *intBookID = @"0";
		[webservice wsListDocumentTypes:hashCode DocumentID:intBookID];	
	}
	else if ([operation isEqualToString:@"GDDocumentType"]) {
		nInitCount++;
		if([recordStack count] > 0){
			NSInteger i = 0, nResult = [recordStack count];
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			//add a default blank value
			[tempArray addObject:@"0#"];
			for(i = 0; i < nResult; i++){
				NSDictionary *recordDict = [recordStack objectAtIndex:i];
				NSDictionary *IDGDDocumentType = [recordDict objectForKey:@"IDGDDocumentType"];
				NSDictionary *GDDocumentType = [recordDict objectForKey:@"GDDocumentType"];				
				NSString *value = [NSString stringWithFormat: @"%@#%@", 
								   [IDGDDocumentType objectForKey:@"value"],
								   [GDDocumentType objectForKey:@"value"]];
				[tempArray addObject:value];			      
			}
			typesArray = [tempArray copy];
			[tempArray release];
		}else{
			//NSLog(@"GDDocumentType Operation failure");
		}
	}
	
	//here completed network init...
	if(!netInitialized){
		if(nInitCount > 1){						
			netInitialized = YES;
			//[navigationController popViewControllerAnimated:YES];
		//	[navigationController2.view removeFromSuperview];
		//	[splashController.view removeFromSuperview];
		//	[splashController release];
		//	[navigationController2 release];
			
			//NSLog(@"show login view");
		//	[window addSubview:navigationController.view];
			//[window makeKeyAndVisible];
			
		}
	}
	
	//[activityIndicator stopAnimating];		
	
}	

- (void)didOperationError:(NSError*)error
{
	nInitCount++;
	if(!netInitialized){
		netInitialized = YES;
		[splashController.view removeFromSuperview];
		[splashController release];
		[window addSubview:navigationController.view];
		[window makeKeyAndVisible];
	}
	
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: [error localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	//[activityIndicator stopAnimating];
	
}

- (void)showGlobalIndicator:(id)isShow{
	UIView *indicatorView = [[window viewWithTag:kTagWindowIndicatorView] retain];
	UIActivityIndicatorView *indicator = [[indicatorView viewWithTag:kTagWindowIndicator] retain];
	if (indicatorView == nil) {
		indicatorView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		indicatorView.backgroundColor = [UIColor clearColor];
		indicatorView.tag = kTagWindowIndicatorView;
		[window addSubview:indicatorView];
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
						initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		indicator.frame = CGRectMake(150, 340, 20, 20);
		indicator.tag = kTagWindowIndicator;
		[indicatorView addSubview:indicator];
	}
	if (isShow != nil) {
		[indicatorView setHidden:NO];
		[indicator startAnimating];
		[window bringSubviewToFront:indicatorView];
	}else {
		[indicatorView setHidden:YES];
		[indicator stopAnimating];
		[window sendSubviewToBack:indicatorView];
	}
	[indicator release];
	[indicatorView release];
	
}

- (void)messageBox:(NSString*)message Error:(NSError*)error{
	
	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: ((error != nil) ? [error localizedDescription]:@"")
							   message: ((error != nil) ? [error localizedFailureReason]:message)
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (NSString *)getCurrentDateTime{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];	
	NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
	[timeFormat setDateFormat:@"HH:mm:ss"];	
	NSDate *now = [[NSDate alloc] init];	
	NSString *theDate = [dateFormat stringFromDate:now];
	NSString *theTime = [timeFormat stringFromDate:now];	
	NSString *result = [NSString stringWithFormat:@"%@ %@",theDate,theTime];
	[dateFormat release];
	[timeFormat release];
	[now release];
	return result;
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			//abort();
        } 
    }
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"WebDoc.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
					name:NSUserDefaultsDidChangeNotification
						  object:nil];
	
	[navigationController release];
	[window release];
	[domainsArray release];
	[typesArray release];
	[workflowStateArray release];
	[teamsArray release];
	[usersArray release];
	[directionArray release];
	[webservice release]; 
	
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
	[window release];
	[super dealloc];
}


@end

