//
//  RootViewController.h
//  SQLite
//
//  Created by Henry Yu on 11/1/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Coffee, AddViewController, DetailViewController;

@interface RootViewController : UITableViewController {
	
	SQLAppDelegate *appDelegate;
	AddViewController *avController;
	DetailViewController *dvController;
	UINavigationController *addNavigationController;
}

@end
