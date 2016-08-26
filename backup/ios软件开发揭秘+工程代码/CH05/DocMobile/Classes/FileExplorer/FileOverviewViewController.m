//
//  FileOverviewViewController.m
//
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import "AppDelegate.h"
#import "FileOverviewViewController.h"
#import "NSData+Base64.h"
#import "NSString+Helpers.h"

@implementation FileOverviewViewController

@synthesize rowImage;
@synthesize fileNameLabel, fileSizeLabel, fileModifiedLabel;
@synthesize activityIndicator;
@synthesize webservice;

-(NSString*) filePath {
	return filePath;
}

-(void) setFilePath: (NSString*) p {
	[p retain];
	[filePath release];
	filePath = p;
	[self updateFileOverview];
	self.title = @"WebDoc Mobile";	
}

- (void)viewDidLoad {
  
}


-(void) updateFileOverview {
	if (self.filePath != NULL) {
		NSString *fileName = [self.filePath lastPathComponent];
		fileNameLabel.text = fileName;
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		NSNumberFormatter *numberFormatter =
		[[NSNumberFormatter alloc] init];
		[numberFormatter setPositiveFormat: @"#,##0.## bytes"];
						
		NSDictionary *fileAttributes =
		[[NSFileManager defaultManager]
			fileAttributesAtPath: self.filePath
			traverseLink: YES]; 
		NSDate *modificationDate = (NSDate*)
			[fileAttributes objectForKey: NSFileModificationDate];
		NSNumber *fileSize = (NSNumber*)
			[fileAttributes objectForKey: NSFileSize];
		fileSizeLabel.text = 
			[numberFormatter stringFromNumber: fileSize];
		fileModifiedLabel.text =
			[dateFormatter stringFromDate: modificationDate];

		[numberFormatter release];
		[dateFormatter release];
		
	}
}


- (IBAction) readFileContents {
		
	if(webservice == nil){	    
	   webservice = [WebDocWebService instance];	
	   webservice.delegate = self;	
	}	
	
	NSString *escapedPath = [filePath stringByReplacingOccurrencesOfString:@" " 
																		 withString:@"%20"];
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *hashCode = appDelegate.hashCode; 	
	NSString *documentId = appDelegate.documentId; 	
		
    NSArray *strings = [escapedPath componentsSeparatedByString: @"/"];
	NSString *documentFilename0  = [strings objectAtIndex:[strings count]-1];
	NSRange iStart = [documentFilename0 rangeOfString :@"."];
	NSString *documentFilename = [documentFilename0 substringToIndex:iStart.location];
	NSString *extension  = [documentFilename0 substringFromIndex:iStart.location+1];
		
	NSString *prefix = [NSString stringWithFormat:
						@"<UploadNewDocumentAttachment xmlns=\"http://tempuri.org/\">\n"
						"<strHashCode>%@</strHashCode>\n"
						"<strDocumentIDEncrypted>%@</strDocumentIDEncrypted>\n",
						hashCode, documentId];
	NSString *postfix = [NSString stringWithFormat:
						 @"<fileExtension>%@</fileExtension>\n"
						 "<strAttachmentName>%@</strAttachmentName>\n"
						 "</UploadNewDocumentAttachment>\n",
						 extension, documentFilename];
	
	NSString *tmpdata = nil;		
	NSString *filePath2 = [NSString stringWithFormat:@"file://%@",escapedPath];
		
	NSURL *url = [NSURL URLWithString: filePath2];
	NSData *imgData = [NSData dataWithContentsOfURL:url]; 
	NSInteger fileLength = [imgData length];
	
	NSMutableString *data = [[[NSMutableString alloc]initWithCapacity:(fileLength + 255)]autorelease];
	[data appendString:prefix];
	[data appendString:@"<fileBuff>"];
	BOOL doUpload = FALSE;
	if(fileLength > 0){
		doUpload  = TRUE;
		[data appendString:[imgData base64EncodedString:0]];
	}else{
	    [appDelegate messageBox:@"ERROR,file data length is 0" Error:nil];
	}
	
	if(doUpload){
		[data appendString:@"</fileBuff>\n"];
		[data appendString:postfix];	
		
		[tmpdata release];
		[webservice wsUpLoadAttachment: data ];
		//TODO: here should notify the caller.
		[activityIndicator startAnimating];
		//[NSThread sleepForTimeInterval:2];
		//uploadButton.enabled = FALSE;
	}
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[webservice release];
	[activityIndicator release];
    [super dealloc];
}

- (void) didOperationCompleted:(NSDictionary *)dict
{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	NSString *alertMessage = @"File upload failure!";
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	appDelegate.reloadFiles = FALSE;
	if ([operation isEqualToString:@"UploadNewDocumentAttachmentResult"]) {
		//if([webservice getRecordCount]){	
		if([recordStack count]){
			//NSDictionary *recordDict = [webservice getRecordAtIndex:0];	
			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"UploadNewDocumentAttachmentResult"];	
			NSString *strResult = [recordDict objectForKey:@"value"];
			
			if([strResult isEqualToString:@"true"]){
				alertMessage = @"File upload ok!";
				 // refresh file list.				
				appDelegate.reloadFiles = TRUE;
			}else{
				NSInteger uploadResult = [strResult intValue];
				if(uploadResult > 0){ //TODO
					alertMessage = @"File upload ok!";
					// refresh file list.
					appDelegate.reloadFiles = TRUE;
				}
			}
			
		}else{
			NSLog(@"UploadNewDocumentAttachmentResult Operation failure");
		}
	}
	
	UIAlertView *cantDeleteAlert =
	[[UIAlertView alloc] initWithTitle:@"Upload"
							   message:alertMessage
							  delegate:nil
					 cancelButtonTitle:@"OK"
					 otherButtonTitles:nil];
	[cantDeleteAlert show];
	[cantDeleteAlert release];	

	[activityIndicator stopAnimating];	
	
	//[self.navigationController popViewControllerAnimated:YES];
	
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
	[activityIndicator stopAnimating];	
	
}

@end
