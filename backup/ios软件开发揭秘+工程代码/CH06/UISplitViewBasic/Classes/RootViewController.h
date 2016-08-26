//
//  RootViewController.h
//  UISplitViewBasic
//
//  Created by Henry Yu on 5/18/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {
    DetailViewController *detailViewController;
	NSMutableArray *categories;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@end
