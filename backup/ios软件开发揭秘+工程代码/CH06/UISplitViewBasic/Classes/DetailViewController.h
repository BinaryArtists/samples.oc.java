//
//  DetailViewController.h
//  UISplitViewBasic
//
//  Created by Henry Yu on 5/18/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HLayoutView;

@interface DetailViewController : UIViewController 
      <UIPopoverControllerDelegate, 
       UISplitViewControllerDelegate,
       UIScrollViewDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    id detailItem;
	int currentCategory;
	int numberOfPhoto;
	HLayoutView *mainLayout;
	NSMutableArray *photoContainers;
}

@property int currentCategory;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;


- (void)loadImages;

@end
