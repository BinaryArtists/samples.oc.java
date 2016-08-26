//
// File: DocumentDetailViewController.m
// Abstract: The view controller for document detail.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import "DocumentDetailViewController.h"
#import "Constants.h"

#import "NSArray+PerformSelector.h"
#import "DocDetailViewController.h"
#import "DocFilesViewController.h"
#import "DocHistoryViewController.h"
#import "DocWorkflowViewController.h"
#import "DirectoryViewController.h"
#import "AppDelegate.h"

@interface DocumentDetailViewController ()

@property (nonatomic, retain, readwrite) IBOutlet UISegmentedControl * segmentedControl;
@property (nonatomic, retain, readwrite) UIViewController            * activeViewController;
@property (nonatomic, retain, readwrite) NSArray                     * segmentedViewControllers;

- (void)didChangeSegmentControl:(UISegmentedControl *)control;
- (NSArray *)segmentedViewControllerContent;

@end

@implementation DocumentDetailViewController

@synthesize delegate;
@synthesize segmentedControl, activeViewController, segmentedViewControllers;
@synthesize rowImage, document, docmentId;
@synthesize directoryViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]));
    
    self.title = NSLocalizedString(@"Document Details", @"");
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *title = appDelegate.currentTitle;
	
    self.navigationItem.prompt = title; 
	self.navigationController.navigationBar.backItem.title =  NSLocalizedString(@"Back", @"");
		
	return self;
}

- (void)viewDidLoad {
	
    [super viewDidLoad];
	
    self.segmentedViewControllers = [self segmentedViewControllerContent];	

#if RECORD_TABS_IMAGE
	NSArray *imageArray = [[NSArray arrayWithObjects:
	 				   [UIImage imageNamed:@"detail.png"],
	 				   [UIImage imageNamed:@"attachment.png"],
	 				   [UIImage imageNamed:@"history.png"],
	 				   [UIImage imageNamed:@"workflow.png"],
	 				   nil] retain];
	self.segmentedControl = [[UISegmentedControl alloc] initWithItems:imageArray];
#else
	NSArray * segmentTitles = [self.segmentedViewControllers arrayByPerformingSelector:@selector(title)];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTitles];	
#endif
	
    self.segmentedControl.selectedSegmentIndex = 0;
	self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.segmentedControl.frame = CGRectMake(0, 0, 400, kCustomButtonHeight);
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	
	[self.segmentedControl addTarget:self
	 action:@selector(didChangeSegmentControl:)
	 forControlEvents:UIControlEventValueChanged];
	// keep track of this for later
	defaultTintColor = [segmentedControl.tintColor retain];	
		
    self.navigationItem.titleView = self.segmentedControl;
    [self.segmentedControl release];
	// kick everything off
    [self didChangeSegmentControl:self.segmentedControl]; 
	 
}

//
- (void)preLoadData{
	DocDetailViewController *detailViewController = [self.segmentedViewControllers objectAtIndex:0];
	[detailViewController viewWillAppear:NO];
	DocFilesViewController *filesViewController = [self.segmentedViewControllers objectAtIndex:1];
	[filesViewController viewWillAppear:NO];
	DocHistoryViewController *historyViewController = [self.segmentedViewControllers objectAtIndex:2];
	[historyViewController viewWillAppear:NO];
}

- (NSArray *)segmentedViewControllerContent {
	
	UIViewController * controller1 = [[DocDetailViewController alloc] initWithParentViewController:self];
    UIViewController * controller2 = [[DocFilesViewController alloc] initWithParentViewController:self];
	UIViewController * controller3 = [[DocHistoryViewController alloc] initWithParentViewController:self];
	UIViewController * controller4 = [[DocWorkflowViewController alloc] initWithParentViewController:self];
	
    NSArray * controllers = [NSArray arrayWithObjects:controller1, controller2,controller3,controller4, nil];
	
	//--------
	docmentId = document.documentId;
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	appDelegate.documentId =  docmentId;

	[(DocDetailViewController*)controller1 setDocumentId:docmentId];
	[(DocFilesViewController*)controller2 setDocumentId:docmentId];
    [(DocHistoryViewController*)controller3 setDocumentId:docmentId];
	[(DocWorkflowViewController*)controller4 setDocumentId:docmentId];	
	//	
    [controller1 release];
    [controller2 release];
	[controller3 release];
    [controller4 release];
	
    return controllers;
}


#pragma mark -
#pragma mark Segment control

- (void)didChangeSegmentControl:(UISegmentedControl *)control {
    if (self.activeViewController) {
        [self.activeViewController viewWillDisappear:NO];
        [self.activeViewController.view removeFromSuperview];
        [self.activeViewController viewDidDisappear:NO];
    }
			
    self.activeViewController = [self.segmentedViewControllers objectAtIndex:control.selectedSegmentIndex];
	//-------------------------------------------------------------------------------
	NSMutableArray* toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
	int a = [toolbarItems count];
	if (a == 0 ) {	
		
		infoButton = [[UIBarButtonItem alloc] 
					  initWithTitle:@"AttachFile" style:UIBarButtonItemStyleBordered target:self action:@selector(browseFileSystem:)];
	
		[toolbar setItems:[NSArray arrayWithObjects:infoButton,nil]];
	}
		
	if(control.selectedSegmentIndex == 1||control.selectedSegmentIndex == 3){
		self.navigationController.toolbarHidden = YES;
		if(control.selectedSegmentIndex == 3)
		    infoButton.title = @"Done";
		else
			infoButton.title = @"AttachFile";
	}else{
		self.navigationController.toolbarHidden = NO;
	}	
	
	//
	[self setNavigatinBarStyle:DEFAULT_STATUS_BAR_STYLE];
	
	//--------------------------------------------------------------------------------
 	[self.activeViewController viewWillAppear:YES];
    [self.view addSubview:self.activeViewController.view];
    [self.activeViewController viewDidAppear:NO];
	
    NSString * segmentTitle = [control titleForSegmentAtIndex:control.selectedSegmentIndex];
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:segmentTitle style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark -
#pragma mark View life cycle

- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
    [self.activeViewController viewWillAppear:animated];
    [self viewWillAppearDetail:NO];	
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.activeViewController viewDidAppear:animated];	
}

- (void)viewWillDisappear:(BOOL)animated {
	self.navigationController.toolbarHidden = YES;
	[toolbar removeFromSuperview];	
    [super viewWillDisappear:animated];
    [self.activeViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.activeViewController viewDidDisappear:animated];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate control

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [viewController viewDidAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	[viewController viewWillAppear:animated];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
    for (UIViewController * viewController in self.segmentedViewControllers) {
        [viewController didReceiveMemoryWarning];
    }
}

- (void)viewDidUnload {
    self.segmentedControl         = nil;
    self.segmentedViewControllers = nil;
    self.activeViewController     = nil;
	directoryViewController = nil;
    [super viewDidUnload];
}

- (void)dealloc
{
	[directoryViewController release];
	[toolbar release];
	[defaultTintColor release];
	[segmentedControl release];
	[super dealloc];	
}


- (void)viewWillAppearDetail:(BOOL)animated 
{
 	//Initialize the toolbar
	toolbar = [[UIToolbar alloc] init];
	//toolbar.barStyle = UIBarStyleDefault;
	[self setNavigatinBarStyle:DEFAULT_STATUS_BAR_STYLE];
	//[toolbar setFrame:CGRectMake(0, 50, 320, 35)];

	//Set the toolbar to fit the width of the app.
	[toolbar sizeToFit];
	
	//Caclulate the height of the toolbar
	CGFloat toolbarHeight = [toolbar frame].size.height;
	
	//Get the bounds of the parent view
	CGRect rootViewBounds = self.parentViewController.view.bounds;
	
	//Get the height of the parent view.
	CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
	
	//Get the width of the parent view,
	CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
	
	//Create a rectangle for the toolbar
	CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
	
	//Reposition and resize the receiver
	[toolbar setFrame:rectArea];
			
	//Add the toolbar as a subview to the navigation controller.
	[self.navigationController.view addSubview:toolbar];
	
	if(self.segmentedControl != nil){
		if(self.segmentedControl.selectedSegmentIndex == 1||
			self.segmentedControl.selectedSegmentIndex == 3){
			NSMutableArray* toolbarItems = [[NSMutableArray arrayWithArray:toolbar.items] retain];
			int a = [toolbarItems count];
			if (a == 0 ) {	
				
				infoButton = [[UIBarButtonItem alloc] 
							  initWithTitle:@"AttachFile" 
							  style:UIBarButtonItemStyleDone target:self action:@selector(browseFileSystem:)];
				[toolbar setItems:[NSArray arrayWithObjects:infoButton,nil]];
			}
			self.navigationController.toolbarHidden = YES;
			if(self.segmentedControl.selectedSegmentIndex == 3)
				infoButton.title = @"Done";
			else
				infoButton.title = @"AttachFile";
		}else{
			self.navigationController.toolbarHidden = NO;
		}
	}else{
	   self.navigationController.toolbarHidden = NO;
	}	
}

// browse file system.
- (void)browseFileSystem:(id)sender {
	
	if(segmentedControl.selectedSegmentIndex == 1){
		if (directoryViewController == nil){
			directoryViewController = [[DirectoryViewController alloc] initWithNibName:
										   @"DirectoryViewController" bundle:nil] ;
			//directoryViewController.directoryPath = NSHomeDirectory();
//			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//			NSString *documentsDirectory = [paths objectAtIndex:0];
//			directoryViewController.directoryPath = documentsDirectory;//[documentsDirectory UTF8String];
	//		directoryViewController.directoryPath = UPLOAD_DIRECTORY; //@"/private/var/mobile/Media";
			directoryViewController.directoryPath = @"/Users/henryyu";
			NSLog(@"directoryPath:%@",directoryViewController.directoryPath);
		}		
					
		[self.navigationController pushViewController:directoryViewController animated:YES];		
		[directoryViewController release];
		directoryViewController = nil;
    }else if(segmentedControl.selectedSegmentIndex == 3){
		//notify the DocWorkflowViewController.
		if ([self.delegate respondsToSelector:@selector(updateWorkflow:)]){
			[self.delegate updateWorkflow:@""];	
		}
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
			toolbar.barStyle = UIBarStyleDefault;
			self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
			break;
		}
		case STATUS_BAR_STYLE_BLACKOQAUE:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
			toolbar.barStyle = UIBarStyleBlackOpaque;
			self.navigationController.navigationBar.barStyle = UIStatusBarStyleBlackOpaque;
			break;
		}
		case STATUS_BAR_STYLE_BLACKTRANSLUCENT:
		{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
			toolbar.barStyle = UIBarStyleBlackTranslucent;
			self.navigationController.navigationBar.barStyle = UIStatusBarStyleBlackTranslucent;
			break;
		}
	}
}

@end
