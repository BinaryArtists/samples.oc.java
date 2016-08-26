//
// File: MainViewController.h
// Abstract: The application's main view controller (front page).
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ModalViewController.h"
#import "TeamViewController.h"


@interface MainViewController : UIViewController <UINavigationBarDelegate, UITableViewDelegate,
												  UITableViewDataSource, UIActionSheetDelegate>
{
	UITableView	*myTableView;
	NSMutableArray *menuList;
	LoginViewController *myLoginViewController;
	ModalViewController *myModalViewController;	
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *menuList;
@property (nonatomic, retain) LoginViewController *myLoginViewController;
@property (nonatomic, retain) ModalViewController *myModalViewController;

- (NSInteger)showLogin;
- (void)setNavigatinBarStyle:(NSInteger)style;

@end
