//
// File: AdvancedSearchViewController.h
// Abstract: The view controller for advanced search.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "DocListViewController.h"
@class UIComboBox;

@interface AdvancedSearchViewController : UIViewController
                          <UINavigationControllerDelegate>{
	UIColor *defaultTintColor;
	NSMutableArray *states;
	NSMutableArray *directions;	
	NSMutableArray *types;
	
	WebDocWebService *webservice;	
	IBOutlet UIButton *searchButton;
	IBOutlet UITextField *codeField;
	UIComboBox *stateField;
	UIComboBox *directionField;
	UIComboBox *typeField;
	IBOutlet UITextField *entryField;
    UIActivityIndicatorView *searchIndicator;
	DocListViewController *targetViewController;	
}

@property(nonatomic, retain) WebDocWebService *webservice;
@property (nonatomic, retain) DocListViewController *targetViewController;
@property (nonatomic, retain) UITextField *codeField;
@property (nonatomic, retain) IBOutlet UIComboBox *stateField;
@property (nonatomic, retain) IBOutlet UIComboBox *directionField;
@property (nonatomic, retain) IBOutlet UIComboBox *typeField;
@property (nonatomic, retain) UITextField *entryField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *searchIndicator;
@property (nonatomic, retain) UIButton *searchButton;

- (void)clearManagedObjectsWithPredicate;
- (IBAction)doSearch:(id)sender;

@end
