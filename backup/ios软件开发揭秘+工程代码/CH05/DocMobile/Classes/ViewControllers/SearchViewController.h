//
// File: SearchViewController.h
// Abstract: The view controller for documents of my teams.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.
#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate <NSObject>
@required
- (UINavigationController *)NavigationController; 
- (void)SearchResultString:(NSString *)newValue;
@end

@interface SearchViewController : UIViewController
    <UISearchBarDelegate,UINavigationControllerDelegate,
     UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate>{
		
	BOOL searching;
	BOOL letUserSelectRow;
	UITableView	*myTableView;	
	NSMutableArray *dataArray;
	NSMutableArray *searchArray;
	UISearchBar *search;
		
	UIView *disableViewOverlay;			
	id<SearchViewControllerDelegate> delegate;
		
}

@property(retain) UIView *disableViewOverlay;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *searchArray;
@property (nonatomic, assign)  id <SearchViewControllerDelegate> delegate;
	
- (void)cancel;
- (void)searchTableView;
- (void)dismissSelfView:(NSString*)item Back:(BOOL)back;
- (void)setNavigatinBarStyle:(NSInteger)style;
- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL)active;
			  
@end


