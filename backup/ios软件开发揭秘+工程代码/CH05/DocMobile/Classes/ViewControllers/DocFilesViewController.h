//
//  DocFilesViewController.h
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WebService.h"

@interface DocFilesViewController : UITableViewController{
    UIViewController * managingViewController;
	NSArray *records;
	WebDocWebService *webservice;
	NSUInteger currentRow;
	NSString  *documentId;
	BOOL bDataFetching;
	UIActivityIndicatorView *activityIndicator;
	//NSFetchedResultsController *fetchedResultsController;
}

@property (nonatomic, retain) NSString *documentId;
//@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) UIViewController *managingViewController;
@property(nonatomic, retain) WebDocWebService *webservice;

- (void)setDocumentId:(NSString *)doc;
- (void)showConfirmAlert:(NSString *)attachment AttachmentId:(NSString*)key;
- (id)initWithParentViewController:(UIViewController *)aViewController;
- (void)removeIndicator;
- (NSArray *)fetchManagedObjectsWithPredicate;
- (void)clearManagedObjectsWithPredicate;
- (BOOL)addAttachment:(NSDictionary *)recordDict DocumentId:(NSString*)document;
- (NSFetchedResultsController *)fetchedResultsController:(NSString*)iDocumentId;

@end


