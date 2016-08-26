//
//  DocDetailViewController.h
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface DocDetailViewController : UIViewController {
    UIViewController * managingViewController;
    NSString *iDocumentId;
	WebDocWebService *webservice;
	IBOutlet UITextField *codeText;
	IBOutlet UITextField *subjectText;
	IBOutlet UITextField *directionText;
	IBOutlet UITextField *typeText;
	IBOutlet UITextField *entryText;
	IBOutlet UITextField *dateText;
	IBOutlet UITextField *stateText;
	BOOL bDataFetching;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, retain) WebDocWebService *webservice;
@property (nonatomic, retain) IBOutlet UITextField *codeText;
@property (nonatomic, retain) IBOutlet UITextField *subjectText;
@property (nonatomic, retain) IBOutlet UITextField *directionText;
@property (nonatomic, retain) IBOutlet UITextField *typeText;
@property (nonatomic, retain) IBOutlet UITextField *entryText;
@property (nonatomic, retain) IBOutlet UITextField *dateText;
@property (nonatomic, retain) IBOutlet UITextField *stateText;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIViewController  *managingViewController;

- (BOOL)reloadFields;
- (void)setDocumentId:(NSString *)docment; 
- (id)initWithParentViewController:(UIViewController *)aViewController;
- (void)removeIndicator;
- (BOOL)updateDocumentDetail:detailDict;

@end

