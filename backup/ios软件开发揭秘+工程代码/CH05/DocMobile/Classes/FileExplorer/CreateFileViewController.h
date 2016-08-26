//
//  CreateFileViewController.h
//
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DirectoryViewController.h"


@interface CreateFileViewController : UIViewController {
	NSString *parentDirectoryPath;
	DirectoryViewController *directoryViewController;
	UITextField *fileNameField;
	UITextView *fileContentsView;

	NSOutputStream *asyncOutputStream;
	NSData *outputData;
	NSRange outputRange;

}


@property (nonatomic,retain) IBOutlet UITextField *fileNameField;
@property (nonatomic,retain) IBOutlet UITextView *fileContentsView;	
@property (nonatomic,retain) NSString *parentDirectoryPath;
@property (nonatomic,retain) DirectoryViewController *directoryViewController;


@end
