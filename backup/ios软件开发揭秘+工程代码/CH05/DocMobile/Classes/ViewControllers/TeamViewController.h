//
//  TeamViewController.h
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamViewController : UITableViewController<UINavigationControllerDelegate> {
   NSArray *records;
}

@property (nonatomic, retain) NSArray *records;

@end
