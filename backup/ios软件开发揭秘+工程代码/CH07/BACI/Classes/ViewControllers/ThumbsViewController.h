//
//  ThumbsViewController.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

@protocol ThumbsViewControllerDelegate;
@class ThumbsView;

@interface ThumbsViewController : UIViewController
{
    id<ThumbsViewControllerDelegate> delegate;
    BOOL dataReloadPending;
    BOOL isVisible;
    ThumbsView *thumbsView;
    CGRect outerFrame;
    CGRect innerFrame;
	CGRect thumbsViewFrame;
	UIView* _imageView;
	UIToolbar *toolbar;
	UIToolbar *toolbar2;
	UIBarButtonItem *_leftBarButton;
}

@property (nonatomic, assign) CGRect outerFrame;
@property (nonatomic, assign) CGRect innerFrame;

@property (nonatomic, retain,readwrite) IBOutlet UIView *imageView;

- (id)initWithDelegate:(id<ThumbsViewControllerDelegate>)_delegate;
- (void)setDelegate:(id<ThumbsViewControllerDelegate>)_delegate;
- (void)createSearchBar;
- (void)createBottomBar;
- (void)resetAllViews;

- (void)reloadData;
- (void)fetchedPhoto:(UIImage *)photo atIndex:(int)index;

- (IBAction)leftBarButtonAction:(id)sender;
- (IBAction)doSearch:(id)sender;
//A. LINGERIE B. EYELASHES C. CATEGORIES D. ABOUTUS
- (IBAction)goLINGERIE:(id)sender;
- (IBAction)goEYELASHES:(id)sender;
- (IBAction)goCATEGORIES:(id)sender;
- (IBAction)goABOUTUS:(id)sender;
- (IBAction)goLINGERIE:(id)sender;

// Private
- (void)thumbTapped:(int)index;
- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation;
- (void)setupPortraitMode;

@end
