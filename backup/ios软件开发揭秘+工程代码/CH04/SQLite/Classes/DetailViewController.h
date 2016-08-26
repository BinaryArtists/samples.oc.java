//
//  DetailViewController.h
//  SQLite
//
//  Created by Henry Yu on 11/1/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Coffee, EditViewController;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate> {

	IBOutlet UITableView *tableView;
	Coffee *coffeeObj;
	NSIndexPath *selectedIndexPath;
	EditViewController *evController;
	
	UIImagePickerController *imagePickerView;
}

@property (nonatomic, retain) Coffee *coffeeObj;

@end
