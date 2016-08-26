//
//  SlideshowViewController.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKCustomAlert : UIAlertView {
	UILabel *alertTextLabel;
	UIButton *alertButton;
	UIImage *backgroundImage;
}

@property(readwrite, retain) UIImage *backgroundImage;
@property(readwrite, retain) NSString *alertText;
- (id)initWithImage:(UIImage *)backgroundImage text:(NSString *)text;
- (void)hideAlert:(id)sender;
@end

@protocol SlideshowViewControllerDelegate;
@class SlideshowView;
@class PageViewController;
@class VideoPlayViewController;
@class PictureViewController;

@interface SlideshowViewController : UIViewController
                     <UIScrollViewDelegate>{
    id<SlideshowViewControllerDelegate> delegate;
    BOOL dataReloadPending;
    BOOL isVisible;
	int controllerType;
	BOOL isPlaying;
	int sereisNameIndex;
	int iOffSet;
	int iPhotoNumber;
	CGRect slidesViewFrame;
    SlideshowView *slideshowView;
	int fromBigType;
    int selectedPhotoIndex;
    UIBarButtonItem *leftArrow;
    UIBarButtonItem *rightArrow;
	PictureViewController *pictureViewController;
	VideoPlayViewController *videoViewController;
	
	UIToolbar *toolbar;
	UIToolbar *toolbar2;
	UIBarButtonItem *_leftBarButton;
	UIToolbar *_bootomToolBar;
	
	//====
	BOOL isFirst,isReachBorder;
	int  lastPageNumber;
	NSInteger currentNumber;					 
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIPageControl *pageControl;
	PageViewController *previousPage;
	PageViewController *currentPage;
	PageViewController *nextPage;
	NSMutableArray *indicatorArray;					 
}
@property BOOL isFirst,isReachBorder;
@property NSInteger currentNumber;
@property int iOffSet,iPhotoNumber,fromBigType;
@property int sereisNameIndex,selectedPhotoIndex,lastPageNumber;

- (void)resetAllViews;
- (void)resetPageControl;
- (IBAction)changePage:(id)sender;
- (void)initPageViewController;
- (void)applyNewIndex:(NSInteger)newIndex pageController:(PageViewController *)pageController;
- (int)getTotalPhotoNumber;
- (int)getTotalPageCount:(int)t;
- (NSArray *)getSortedSeries;
- (void)doScrollViewDidEndScrolling;
- (void)reloadData2:(int)index;
- (void)adjustLastPageFromBigView:(int)index;
- (void)showFirstPage;
- (void)fetchedBigThumb:(UIImage *)photo atIndex:(int)index atPage:(int)page type:(int)t;
- (int)indicatorAtArray:(int)index;
- (void)indicatorArraySet:(int)index Value:(int)v;
- (void)resetPageOrder;
- (int)findIndexBySeriesId:(int)sId;

//
- (void)initSeriesViews;
- (void)initSeriesIndicator;
- (id)initWithDelegate:(id<SlideshowViewControllerDelegate>)_delegate;
- (void)setDelegate:(id<SlideshowViewControllerDelegate>)_delegate Type:(int)t;
- (void)createBottomBar;
- (void)reloadData;
- (void)fetchedPhoto:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location;
- (void)showPhotoAtIndex:(int)index;
- (void)playVideo:(NSString *)file;
- (void)showFullScreenPhoto:(NSString *)filename;

// Private
- (void)didNavigate;
- (void)showPrevPhoto;
- (void)showNextPhoto;
- (BOOL)reloadDataIfNeeded:(int)index;
- (void)scrolledToIndex:(int)index;

-(IBAction)leftBarButtonAction:(id)sender;
-(IBAction)doSearch:(id)sender;
//A. LINGERIE B. EYELASHES C. CATEGORIES D. ABOUTUS
-(void)backToSeries;
-(IBAction)goLINGERIE:(id)sender;
-(IBAction)goEYELASHES:(id)sender;
-(IBAction)goCATEGORIES:(id)sender;
-(IBAction)goABOUTUS:(id)sender;
-(IBAction)goLINGERIE:(id)sender;
- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation;
- (void)setupPortraitMode;
- (int)getCurrentOffset;
- (void)doLoadData:(PageViewController*)c;
@end
