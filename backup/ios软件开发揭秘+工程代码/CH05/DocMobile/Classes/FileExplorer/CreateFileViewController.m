//
//  CreateFileViewController.m
//  
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import "CreateFileViewController.h"


@implementation CreateFileViewController

@synthesize parentDirectoryPath, directoryViewController;
@synthesize fileNameField, fileContentsView;

// this is the blocking way to write the file with an NSOutputStream
- (void)  createNewFile {
	NSString *newFilePath =	[parentDirectoryPath
				stringByAppendingPathComponent: fileNameField.text];
	
	[[NSFileManager defaultManager] createFileAtPath:newFilePath
		contents:nil attributes:nil];
	NSOutputStream *outputStream =
	[NSOutputStream outputStreamToFileAtPath: newFilePath
		append:NO];
	[outputStream open];
	const char* cString = [fileContentsView.text UTF8String];
	UInt16 stringOffset = 0;
	uint8_t outputBuf [1];
	while ( ((outputBuf[0] = cString[stringOffset]) != 0) &&
		   [outputStream hasSpaceAvailable] ) {
		[outputStream write: (const uint8_t *) outputBuf maxLength: 1];
		stringOffset++;
	}
	[outputStream close];
	
	// force update of previous page
	[directoryViewController loadDirectoryContents];
	[directoryViewController.tableView reloadData];
	
	// dismiss this view
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void) setUpAsynchronousContentSave {
	[asyncOutputStream release];
	[outputData release];
	outputData = [[fileContentsView.text  
		dataUsingEncoding: NSUTF8StringEncoding] retain];
	outputRange.location = 0; 
	NSString *newFilePath =	[parentDirectoryPath
			stringByAppendingPathComponent: fileNameField.text];
	[[NSFileManager defaultManager] createFileAtPath:newFilePath
			contents:nil attributes:nil];
	asyncOutputStream =	[[NSOutputStream alloc] 
						 initToFileAtPath: newFilePath append: NO];
	[asyncOutputStream setDelegate: self];
	[asyncOutputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] 
					forMode:NSDefaultRunLoopMode];
	[asyncOutputStream open]; 
}	

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	NSOutputStream *outputStream = (NSOutputStream*) theStream;
	BOOL shouldClose = NO;
	switch (streamEvent) {
		case NSStreamEventHasSpaceAvailable: {
			uint8_t outputBuf [1]; 
			outputRange.length = 1;
			[outputData getBytes:&outputBuf range:outputRange];  
			[outputStream write: outputBuf maxLength: 1];  
			if (++outputRange.location == [outputData length]) {  
				shouldClose = YES;
			}
			break;
		}
		case NSStreamEventErrorOccurred: {
			// dialog the error
			NSError *error = [theStream streamError];
			if (error != NULL) {
				UIAlertView *errorAlert = [[UIAlertView alloc]
				   initWithTitle: [error localizedDescription]
				   message: [error localizedFailureReason]
				   delegate:nil
				   cancelButtonTitle:@"OK"
				   otherButtonTitles:nil];
				[errorAlert show];
				[errorAlert release];
			}
			shouldClose = YES;
			break;
		}
		case NSStreamEventEndEncountered:
			shouldClose = YES;
	}
	if (shouldClose) {
		[outputStream removeFromRunLoop: [NSRunLoop currentRunLoop] 
			forMode:NSDefaultRunLoopMode];
		[theStream close]; 
		
		// force update of previous page and dismiss view
		[directoryViewController loadDirectoryContents];  
		[directoryViewController.tableView reloadData];
		[self.navigationController popViewControllerAnimated:YES]; 
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[fileNameField resignFirstResponder];
	return YES;
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *saveButton =
		[[UIBarButtonItem alloc]
			initWithBarButtonSystemItem: UIBarButtonSystemItemSave
			target: self
			action: @selector(setUpAsynchronousContentSave)];
	 self.navigationItem.rightBarButtonItem = saveButton;
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
	[asyncOutputStream release];
	[fileNameField release];
	[fileContentsView release];
	[outputData release];
    [super dealloc];
}


@end
