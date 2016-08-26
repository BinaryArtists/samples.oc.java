//
// File: MainViewController.m
// Abstract: The application's main view controller (front page).
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import "MainViewController.h"
#import "SplashViewController.h"
#import "AdvancedSearchViewController.h"
#import "StatisticsViewController.h"
#import "DocumentDetailViewController.h"
#import "ModalViewController.h"
#import "DocListViewController.h"
#import "Constants.h"	
#import "AppDelegate.h"

@implementation MainViewController

@synthesize myLoginViewController;
@synthesize menuList, myTableView, myModalViewController;


static NSArray *pageNames = nil;

- (void)dealloc{
    [myTableView release];
	[menuList release];
	if (self.myModalViewController != nil)
		[myModalViewController release];
	[super dealloc];
	
}

- (void)viewDidLoad{
   	[self setNavigatinBarStyle:DEFAULT_STATUS_BAR_STYLE];
}

- (NSInteger)showLogin{
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if([appDelegate getLoginResult])
		return 1;
	
	if (self.myLoginViewController == nil)
        self.myLoginViewController = [[[LoginViewController alloc] initWithNibName:
									   NSStringFromClass([LoginViewController class]) bundle:nil] autorelease];
	
	[self.navigationController presentModalViewController:self.myLoginViewController animated:YES];
		
	return 0; 
}

- (void)viewDidLoadMain{
	// Make the title of this page the same as the title of this app
	self.title = @"WebDoc Mobile";		
	self.menuList = [NSMutableArray array];	
    if (!pageNames)
	{
		pageNames = [[NSArray alloc] initWithObjects:@"DocumentList", @"Splash", 
					 @"AdvancedSearch", @"Statistics", @"DocumentDetail", nil];
    }
	
	[self.menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							  NSLocalizedString(@"Documents To Me", @""), kTitleKey,
							  NSLocalizedString(@" " , @""), kDetailKey,
							  nil]];
	
	[self.menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							  NSLocalizedString(@"Documents To Departments", @""), kTitleKey,
							  NSLocalizedString(@" ", @""), kDetailKey,
							  nil]];
	
	
 	[self.menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							  NSLocalizedString(@"Advanced Search", @""), kTitleKey,
							  NSLocalizedString(@" ", @""), kDetailKey,
							  nil]];	
	
 	[self.menuList addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
							  NSLocalizedString(@"BI Indicators", @""), kTitleKey,
							  NSLocalizedString(@" ", @""), kDetailKey,
							  nil]];
	
    // Create a final modal view controller
	UIButton* modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[modalViewButton addTarget:self action:@selector(modalViewAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
	self.navigationItem.rightBarButtonItem = modalBarButtonItem;
	[modalBarButtonItem release];
	
	[self.myTableView reloadData];		
			
}

- (void)viewDidUnload{
	self.myTableView = nil;
	self.menuList = nil;
}

- (void)viewWillAppear:(BOOL)animated{

	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	if(![appDelegate getLoginResult])
		[self showLogin];
	
	if([appDelegate getLoginResult]){
	   [self viewDidLoadMain];
	   [self.myTableView deselectRowAtIndexPath:self.myTableView.indexPathForSelectedRow animated:YES];
	}
 
}

//
- (void)setNavigatinBarStyle:(NSInteger)style{
    // Change the navigation bar style, also make the status bar match with it
	switch (style)
	{
		case STATUS_BAR_STYLE_DEFAULT:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
			self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
			break;
		}
		case STATUS_BAR_STYLE_BLACKOQAUE:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
			self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
			break;
		}
		case STATUS_BAR_STYLE_BLACKTRANSLUCENT:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
			self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			break;
		}
	}
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kCellIdentifier = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (!cell)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
        
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.opaque = NO;
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.highlightedTextColor = [UIColor whiteColor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
		
		cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		cell.detailTextLabel.opaque = NO;
		cell.detailTextLabel.textColor = [UIColor grayColor];
		cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
	// get the view controller's info dictionary based on the indexPath's row
    NSDictionary *dataDictionary = [menuList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dataDictionary valueForKey:kTitleKey];
    cell.detailTextLabel.text = [dataDictionary valueForKey:kDetailKey];
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	int a = 0;
    NSMutableDictionary *rowData = [self.menuList objectAtIndex:indexPath.row];
	UIViewController *targetViewController = [rowData objectForKey:kViewControllerKey];
	if (!targetViewController)
	{
        // The view controller has not been created yet, create it and set it to our menuList array
        NSString *viewControllerName = [[pageNames objectAtIndex:indexPath.row] stringByAppendingString:@"ViewController"];
		
		AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		NSString *currentView = appDelegate.currentView;		
		if ([viewControllerName isEqualToString: @"DocumentListViewController"]){			
			a = 1;		    
			viewControllerName = @"DocListViewController";
			if ([currentView isEqualToString: @"MyDocumentView"]){
			}else{
				[appDelegate clearCache];	
			}
			[appDelegate setCurrentView:@"MyDocumentView"];
		}else if ([viewControllerName isEqualToString: @"SplashViewController"]){			
			a = 2;				
			viewControllerName = @"TeamViewController";
			if ([currentView isEqualToString: @"MyTeamDocumentView"]){
			}else{
				[appDelegate clearCache];	
			}
			[appDelegate setCurrentView:@"MyTeamDocumentView"];
		}else if([viewControllerName isEqualToString: @"StatisticsViewController"]){
			a = 3;	
		}else{			
			 NSString *viewName = [[pageNames objectAtIndex:indexPath.row] stringByAppendingString:@"View"];
			 [appDelegate setCurrentView:viewName];
		}
		
		
		targetViewController = [[NSClassFromString(viewControllerName) alloc] initWithNibName:viewControllerName bundle:nil];
	    
	
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release]; 
		
		[rowData setValue:targetViewController forKey:kViewControllerKey];
		if(a == 1){				
		  targetViewController.title = @"Documents To Me";
		}else if(a == 2){
		  targetViewController.title = @"Documents To Departments";
		}else if(a == 3){
		  targetViewController.title =	@"BI Indicators";
		}
		
        [targetViewController release];
    }
    [self.navigationController pushViewController:targetViewController animated:YES];
}


- (IBAction)modalViewAction:(id)sender{
    if (self.myModalViewController == nil)
        self.myModalViewController = [[[ModalViewController alloc] initWithNibName:
										NSStringFromClass([ModalViewController class]) bundle:nil] autorelease];

	[self.navigationController presentModalViewController:self.myModalViewController animated:YES];
}

@end

