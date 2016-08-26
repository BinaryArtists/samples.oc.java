//
//  FileOverviewViewController.h
//
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import <UIKit/UIKit.h>
#import "WebService.h";

@interface FileOverviewViewController : UIViewController<UINavigationControllerDelegate> {
	NSString *filePath;
	UIImage *rowImage;
	UILabel *fileNameLabel;
	UILabel *fileSizeLabel;
	UILabel *fileModifiedLabel;
	WebDocWebService *webservice;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

-(void) updateFileOverview;
-(IBAction) readFileContents;

@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) UIImage *rowImage;
@property (nonatomic, retain) WebDocWebService *webservice;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *fileNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *fileSizeLabel;
@property (nonatomic, retain) IBOutlet UILabel *fileModifiedLabel;



@end
