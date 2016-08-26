//
//  PageViewController.h
//  PageControl
//
//  Created by Henry Yu on 10-11-17.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwipeView;
@interface PageViewController : UIViewController {
    SwipeView *contentView;
	int currentPage;
}

@end

