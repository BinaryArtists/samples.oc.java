//
//  CreateDirectoryViewController.h
//  
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DirectoryViewController.h"

@interface CreateDirectoryViewController : UIViewController {
	NSString *parentDirectoryPath;
	DirectoryViewController *directoryViewController;
	IBOutlet UITextField *directoryNameField;
	
}

@property (nonatomic,retain) NSString *parentDirectoryPath;
@property (nonatomic,retain) DirectoryViewController *directoryViewController;

@end
