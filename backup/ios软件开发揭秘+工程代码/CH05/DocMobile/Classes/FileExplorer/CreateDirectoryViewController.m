//
//  CreateDirectoryViewController.m
//  
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import "CreateDirectoryViewController.h"


@implementation CreateDirectoryViewController

@synthesize parentDirectoryPath, directoryViewController;

 
- (void)  createNewDirectory {
	[directoryNameField resignFirstResponder];
	NSString *newDirectoryPath =
		[parentDirectoryPath stringByAppendingPathComponent:
			directoryNameField.text];
	[[NSFileManager defaultManager] 
		createDirectoryAtPath:newDirectoryPath
		attributes: nil];
	
	[directoryViewController loadDirectoryContents];
	[directoryViewController.tableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == directoryNameField)
		[directoryNameField resignFirstResponder];
	return YES;
}


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *saveButton =
		[[UIBarButtonItem alloc]
			initWithBarButtonSystemItem: UIBarButtonSystemItemSave
			target: self
			action: @selector(createNewDirectory)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	// Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[parentDirectoryPath release];
	[directoryViewController release];
    [super dealloc];
}


@end
