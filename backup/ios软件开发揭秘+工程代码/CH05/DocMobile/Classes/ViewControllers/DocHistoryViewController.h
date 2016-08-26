//
//  DocHistoryViewController.h
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "LongTextFieldViewController.h"

@interface DocHistoryViewController : UITableViewController
        <LongTextFieldEditingViewControllerDelegate> {
    UIViewController * managingViewController;
	WebDocWebService *webservice;
	NSArray *records;
	NSString  *documentId;
	BOOL bDataFetching;
	UIActivityIndicatorView *activityIndicator;
	//NSFetchedResultsController *fetchedResultsController;
}

//@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) NSString *documentId;
@property (nonatomic, retain) UIViewController  *managingViewController;
@property(nonatomic, retain) WebDocWebService *webservice;

- (void)setDocumentId:(NSString *)doc;
- (id)initWithParentViewController:(UIViewController *)aViewController;
- (void)removeIndicator;
- (NSArray *)fetchManagedObjectsWithPredicate;
- (void)clearManagedObjectsWithPredicate;
- (BOOL)addHistory:(NSDictionary *)recordDict DocumentId:(NSString*)document;
- (NSFetchedResultsController*)fetchedResultsController:(NSString*)iDocumentId;

@end
