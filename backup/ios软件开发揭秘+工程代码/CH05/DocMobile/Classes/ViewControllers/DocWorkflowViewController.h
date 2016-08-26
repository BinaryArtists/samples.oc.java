//
//  DocWorkflowViewController.h
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "LongTextFieldViewController.h"
#import "DocumentDetailViewController.h"
#import "SearchViewController.h"
#import "WebService.h";
#import "MyTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface DocWorkflowViewController : UIViewController
     <SearchViewControllerDelegate,
      LongTextFieldEditingViewControllerDelegate,
      DocumentDetailViewControllerDelegate,
      UITextFieldDelegate,
      MyTextFieldDelegate>
{
	NSString  *documentId;
    UIViewController *managingViewController;
	UIToolbar *uiToolbar;
	NSInteger currentTag;

	MyTextField *stateField;
	MyTextField *teamField;	
	MyTextField *userField;
	
	BOOL firstComment;
	NSInteger savedState;
	NSInteger savedTeam;
	UITextView *commentField;
	NSMutableArray *states;
	NSMutableArray *teams;	
	NSMutableArray *users;
	WebDocWebService *webservice;	
	BOOL bDataFetching;
	IBOutlet UIActivityIndicatorView *activityIndicator;	
}

@property (nonatomic, retain) NSMutableArray *states;
@property (nonatomic, retain) NSMutableArray *teams;
@property (nonatomic, retain) NSMutableArray *users;
@property (nonatomic, retain) NSString  *documentId;
@property(nonatomic, retain) WebDocWebService *webservice;

@property(nonatomic, retain) IBOutlet MyTextField *stateField;
@property(nonatomic, retain) IBOutlet MyTextField *teamField;
@property(nonatomic, retain) IBOutlet MyTextField *userField;

@property(nonatomic, retain) IBOutlet UITextView *commentField;
@property (nonatomic, retain) UIViewController  *managingViewController;
@property (nonatomic, retain) IBOutlet UIToolbar *uiToolbar;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)refreshTeamList;
- (void)refreshUserList;
- (NSString *)formatLongTextWithDotDot:(NSString *)inputString MaxLength:(int)len;
- (id)initWithParentViewController:(UIViewController *)aViewController;
- (IBAction)addComment:(id)sender;


@end
