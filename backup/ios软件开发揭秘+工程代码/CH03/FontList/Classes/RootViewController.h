//
//  RootViewController.h
//  FontList
//
//  Created by Henry Yu on 11/17/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
    NSMutableArray *fontNames;
}

@property(nonatomic, retain)NSMutableArray *fontNames;

@end
