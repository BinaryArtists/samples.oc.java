//
//  RootViewController.m
//
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import "DirectoryViewController.h"
#import "FileOverviewViewController.h"
#import "CreateDirectoryViewController.h"
#import "CreateFileViewController.h"


@implementation DirectoryViewController
@synthesize rowImage;

-(NSString*) directoryPath {
	return directoryPath;
}

-(void) setDirectoryPath: (NSString*) p {
	[p retain];
	[directoryPath release];
	directoryPath = p;
	[self loadDirectoryContents];
	// also set title of nav controller with last path element
	NSString *pathTitle= [directoryPath lastPathComponent];
	self.title = pathTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
		numberOfRowsInSection:(NSInteger)section {
	return [directoryContents count];
}

- (UITableViewCell *)tableView:(UITableView *)table
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DirectoryViewCell";
	UITableViewCell *cell =
		[table dequeueReusableCellWithIdentifier:
		CellIdentifier];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc]
			initWithStyle:UITableViewCellStyleDefault
			reuseIdentifier:CellIdentifier] autorelease];
	}
	
	//-----------------------------------------------------------
	NSString *selectedFile = (NSString*)[directoryContents objectAtIndex: indexPath.row];
	BOOL isDir;
	NSString *selectedPath = [directoryPath stringByAppendingPathComponent: selectedFile];
	if ([[NSFileManager defaultManager]fileExistsAtPath:selectedPath isDirectory:&isDir] && isDir) {
		cell.imageView.image = [UIImage imageNamed: @"folder.png"];	
	}else{
		cell.imageView.image = [UIImage imageNamed: @"file.png"];	
	}
		
    cell.textLabel.text = selectedFile;	
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 

	return cell;
}


- (void)tableView:(UITableView *)tableView 
		commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
		forRowAtIndexPath:(NSIndexPath *)indexPath {
	// handle a delete swipe
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSString *selectedFile = (NSString*)[directoryContents objectAtIndex: indexPath.row];
		NSString *selectedPath = [directoryPath stringByAppendingPathComponent:	selectedFile];
		BOOL canWrite =	[[NSFileManager defaultManager]	isWritableFileAtPath: selectedPath];
		if (! canWrite) {
			// show a UIAlert saying path isn't writable
			NSString *alertMessage = [NSString stringWithFormat: @"Cannot delete %@", selectedFile];
			UIAlertView *cantWriteAlert =
				[[UIAlertView alloc] initWithTitle:@"Not permitted:"
						message:alertMessage
						delegate:nil
						cancelButtonTitle:@"OK"
						otherButtonTitles:nil];
			[cantWriteAlert show];
			[cantWriteAlert release];
			return;
		}
		
		// try to delete 
		NSError *err = nil;
		if (! [[NSFileManager defaultManager] removeItemAtPath: selectedPath error:&err]) {
			// show a UIAlert saying cannot delete
			NSString *alertMessage = (err == noErr) ?
				[NSString stringWithFormat: @"Cannot delete %@", selectedFile] :
				[NSString stringWithFormat: @"Cannot delete %@, %@",
						selectedFile, [err localizedDescription]];
			UIAlertView *cantDeleteAlert =
				[[UIAlertView alloc] initWithTitle:@"Can't delete:"
						message:alertMessage
						delegate:nil
						cancelButtonTitle:@"OK"
						otherButtonTitles:nil];
			[cantDeleteAlert show];
			[cantDeleteAlert release];
			return;
		}
		
		// refresh display
		NSArray *deletedPaths = [NSArray arrayWithObject: indexPath];
		[self loadDirectoryContents];
		[self.tableView deleteRowsAtIndexPaths: deletedPaths
			withRowAnimation: YES];
	}
}

- (void)tableView:(UITableView *)tableView
		didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *selectedFile = (NSString*)[directoryContents objectAtIndex: indexPath.row];

	BOOL isDir;
	NSString *selectedPath = [directoryPath stringByAppendingPathComponent: selectedFile];

	if ([[NSFileManager defaultManager]fileExistsAtPath:selectedPath isDirectory:&isDir] && isDir) {		

		DirectoryViewController *directoryViewController = 
		       [[DirectoryViewController alloc]				 
				initWithNibName: @"DirectoryViewController"
				bundle:nil];
		[[self navigationController]
			pushViewController:directoryViewController animated:YES];
		
		directoryViewController.directoryPath = selectedPath;
		[directoryViewController release];
		
	}	
	else {
		
		FileOverviewViewController *fileOverviewViewController =
			[[FileOverviewViewController alloc]
				initWithNibName: @"FileOverviewView"
				bundle:nil];
		
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release]; 
		
		[[self navigationController]
			pushViewController:fileOverviewViewController animated:YES];
	
		fileOverviewViewController.filePath = selectedPath;
		[fileOverviewViewController release];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	/*
	UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] 
		initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
		target:self
		action:@selector(showAddOptions)] autorelease];
	
	 self.navigationItem.rightBarButtonItem = addButton;			
	*/
}

-(void) showAddOptions {
	NSString *sheetTitle = [[NSString alloc]
			initWithFormat: @"Edit \"%@\"",
			[directoryPath lastPathComponent]];
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
			initWithTitle: sheetTitle
			delegate: self
			cancelButtonTitle: @"Cancel"
			destructiveButtonTitle: NULL
			otherButtonTitles: @"New File", @"New Directory", NULL];
	[actionSheet showInView: self.view];
	[sheetTitle release];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
		clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) 
		[self createNewFile];
	else if (buttonIndex == 1)
		[self createNewDirectory];
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
    [super dealloc];
	[directoryContents release];
	[directoryPath release];
}


- (void)createNewFile  {
	BOOL canWrite = [[NSFileManager defaultManager]
						isWritableFileAtPath: self.directoryPath];
	if (! canWrite) {
		NSString *alertMessage = @"Cannot write to this directory";
		UIAlertView *cantWriteAlert =
		[[UIAlertView alloc] initWithTitle:@"Not permitted:"
						message:alertMessage delegate:nil
						cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[cantWriteAlert show];
		[cantWriteAlert release];
		return;
	}
	// present modal view controller to name file
	CreateFileViewController *createFileViewController =
		[[CreateFileViewController alloc]
			initWithNibName: @"CreateFileView"
			bundle:nil];
	createFileViewController.parentDirectoryPath = directoryPath;
	createFileViewController.directoryViewController = self;
	createFileViewController.title = @"Create file";
	[[self navigationController]
		pushViewController:createFileViewController animated:YES];
	[createFileViewController release];
}

- (void)createNewDirectory {
	BOOL canWrite = [[NSFileManager defaultManager]
			isWritableFileAtPath: self.directoryPath];
	if (! canWrite) {
		NSString *alertMessage = @"Cannot write to this directory";
		UIAlertView *cantWriteAlert =
			[[UIAlertView alloc] initWithTitle:@"Not permitted:"
				message:alertMessage
				delegate:nil
				cancelButtonTitle:@"OK"
				otherButtonTitles:nil];
		[cantWriteAlert show];
		[cantWriteAlert release];
		return;
	}
	CreateDirectoryViewController *createDirectoryViewController =
		[[CreateDirectoryViewController alloc]
			initWithNibName: @"CreateDirectoryView"
			bundle:nil];
	createDirectoryViewController.parentDirectoryPath = directoryPath;
	createDirectoryViewController.directoryViewController = self;
	createDirectoryViewController.title = @"Create directory";
	[[self navigationController]
		pushViewController:createDirectoryViewController animated:YES];
	[createDirectoryViewController release];
}

- (void) loadDirectoryContents {

	[directoryContents release];
	directoryContents = [[NSMutableArray alloc] init];
	directoryContents = [[NSFileManager defaultManager]
		directoryContentsAtPath: directoryPath];
	
	[directoryContents retain];
}


@end

