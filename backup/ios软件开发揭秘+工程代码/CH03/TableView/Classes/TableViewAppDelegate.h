//
//  TableViewAppDelegate.h
//  TableView
//
//  Created by Henry Yu on 10/21/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewController;

@interface TableViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TableViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

