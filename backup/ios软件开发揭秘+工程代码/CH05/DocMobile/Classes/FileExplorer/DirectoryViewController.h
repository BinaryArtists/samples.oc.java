//
//  RootViewController.h
//  
//  Created by Henry Yu on 09-06-18.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DirectoryViewController : UITableViewController <UINavigationControllerDelegate,
                                                         UIActionSheetDelegate> {
	NSString *directoryPath;
	NSArray *directoryContents;	
	UIImage *rowImage;
														 
}

@property (nonatomic, retain) UIImage *rowImage;
@property (nonatomic, retain) NSString *directoryPath;

- (void)createNewFile;
- (void)createNewDirectory;
- (void)loadDirectoryContents;

@end
