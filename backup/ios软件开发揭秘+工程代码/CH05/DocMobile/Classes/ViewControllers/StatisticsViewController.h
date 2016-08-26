//
//  StatisticsViewController.h
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndicatorCell.h"
#import "WebService.h"

@interface StatisticsViewController : UIViewController 
                     <UINavigationBarDelegate, UITableViewDelegate,
                       UITableViewDataSource, UIActionSheetDelegate>
{
	NSMutableDictionary *iconList;
	WebDocWebService *webservice;
	UITableView	*myTableView;
	IndicatorCell *tmpCell;
    NSMutableArray *data;
	UIBarButtonItem *prevButton;
	UIBarButtonItem *nextButton;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) NSMutableDictionary *iconList;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *prevButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, assign) IBOutlet IndicatorCell *tmpCell;
@property (nonatomic, retain) NSMutableArray *data;
@property(nonatomic, retain) WebDocWebService *webservice;

- (void)initIconList;
- (void)removeIndicator;
- (void)previousAction:(id)sender;
- (void)nextAction:(id)sender;

@end
