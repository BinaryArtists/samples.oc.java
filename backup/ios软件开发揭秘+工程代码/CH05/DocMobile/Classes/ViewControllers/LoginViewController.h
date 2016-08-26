//
//  LoginViewController.h
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@class UIComboBox;

@interface LoginViewController : UIViewController<UINavigationControllerDelegate> 
{
	NSMutableArray *domains;	
	IBOutlet UITextField *usernameText;
	IBOutlet UITextField *passwordText;
	IBOutlet UISegmentedControl *loginButton;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	IBOutlet UINavigationBar *navigationBar;
	
	int nInitCount;
	WebDocWebService *webservice;	
	UIComboBox* domainsField;	
}

@property (nonatomic, retain) UITextField *usernameText;
@property (nonatomic, retain) UITextField *passwordText;
@property(nonatomic, retain) IBOutlet UIComboBox* domainsField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *loginButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, retain) WebDocWebService *webservice;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)doLogin:(id)sender;
- (void)showMainMenu;
- (void)setNavigatinBarStyle:(NSInteger)style;

@end
