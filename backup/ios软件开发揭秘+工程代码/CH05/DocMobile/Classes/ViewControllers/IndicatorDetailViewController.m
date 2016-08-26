//
//  IndicatorDetailViewController.m
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "IndicatorDetailViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "NSData+Base64.h"

@implementation IndicatorDetailViewController
@synthesize  webservice,indicatorId; 

- (void)viewDidLoad {
    [super viewDidLoad];
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *hashCode = appDelegate.hashCode; 	
	if(webservice == nil){
		webservice = [WebDocWebService instance];	
		webservice.delegate = self;		
	}
	
	[webservice wsGetIndicatorDetailsImage:hashCode Indicator:indicatorId];
	
	//start animating...
	activityIndicator = [[UIActivityIndicatorView alloc] 
						 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);		
	activityIndicator.center = self.view.center;
	[self.view addSubview: activityIndicator];
	[activityIndicator startAnimating];	
	
	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	if(imgData != nil)
		[imgData release];
    [super dealloc];
}

- (void)displayImage{
	if(imageView != nil){
		[imageView release];		
	}
	UIImage *image = [UIImage imageWithData: imgData]; 
	if(image){
	    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height) ];
	    [imageView setImage:image];
		[self.view addSubview:imageView];
	}else{
	    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160,12)];
	    myLabel.text = @"No data available";	
		[self.view addSubview:myLabel];
	}	

}

- (void)removeIndicator{
	if(activityIndicator != nil){
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator = nil;	
	}
}

- (void) didOperationCompleted:(NSDictionary *)dict{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	if ([operation isEqualToString:@"GetIndicatorDetailsImageResult"]) {

		if([recordStack count]){

			NSDictionary *recordDict = [[recordStack objectAtIndex:0] objectForKey:@"GetIndicatorDetailsImageResult"];
			 NSString* base64Binary = [recordDict objectForKey:@"value"];
			 if(imgData != nil)
				 [imgData release];
			 imgData = [NSData dataFromBase64String:base64Binary];
			 [self displayImage];
		}else{
			//AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];	
			//[appDelegate messageBox:@"GetIndicatorDetailsImage Operation failure" Error:nil];
		}
	}
	
	[self removeIndicator];			
	
}	

- (void)didOperationError:(NSError*)error{

	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: [error localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	
	[self removeIndicator];		
}


@end
