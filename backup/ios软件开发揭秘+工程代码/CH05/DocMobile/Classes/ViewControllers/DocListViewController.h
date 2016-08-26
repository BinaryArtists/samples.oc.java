//
//  DocListViewController.h
//  
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WebService.h";
#import "ApplicationCell.h"


@interface DocListViewController : UIViewController 
	<UINavigationBarDelegate, UITableViewDelegate,
	UITableViewDataSource, UIActionSheetDelegate>{
	ApplicationCell *tmpCell;
    NSMutableArray *controllers;
	UITableView	*myTableView;
	NSArray *parameters;
	UIBarButtonItem *prevButton;
	UIBarButtonItem *nextButton;
	NSInteger teamId;
	NSString *teamName;
	NSInteger totalPage;
	NSInteger currentPage;
//	NSInteger totalRecords;
	WebDocWebService *webservice;	
	BOOL bFetching;
	UIActivityIndicatorView *activityIndicator;
	BOOL firstInsert;
	NSFetchedResultsController *fetchedResultsController;		
}

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, assign) IBOutlet ApplicationCell *tmpCell;
@property (nonatomic, retain) NSArray *parameters;
@property (nonatomic, retain) NSMutableArray *controllers;
@property(nonatomic, retain)  WebDocWebService *webservice;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *prevButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;

- (void)setCurrentPage;
- (void)setTeamId:(NSInteger)team;
- (void)setTeamName:(NSString *)teamName;
- (void)setParameters:(NSArray *)args;
- (void)previousAction:(id)sender;
- (void)nextAction:(id)sender;
- (void)handleWithCache;
- (void)makeControllers:(NSArray*)array;
- (void)removeIndicator;
- (NSInteger)makeTotalPage:(int)totalRecords;
- (NSArray *)fetchManagedObjectsWithPredicate;
- (void)clearManagedObjectsWithPredicate:(NSManagedObject*)except;
- (BOOL)addDocument:(NSNumber*)page Team:(NSNumber*)team Data:(NSDictionary *)dict Category:(NSString*)category;
- (NSFetchedResultsController*)fetchedResultsController;

@end
