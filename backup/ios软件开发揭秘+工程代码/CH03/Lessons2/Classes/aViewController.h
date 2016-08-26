//
//  aViewController.h
//  TabBar plus NavBar
//
//  Created by Pierre Addoum on 11/27/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


//@interface aViewController : UITableViewController {
@interface aViewController: UIViewController
               <UITableViewDelegate,
               UITableViewDataSource> {
	UITableView	*thTableView;
	NSMutableArray *data; 
    UIColor *background;
}

//@property (nonatomic, retain) IBOutlet UITableView *myTableView;
//- (id)initWithStyle:(UITableViewStyle)style;

@end
