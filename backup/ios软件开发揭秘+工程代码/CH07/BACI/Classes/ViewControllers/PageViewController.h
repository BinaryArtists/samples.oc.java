//
//  PageViewController.h
//  PagingScrollView
//
//  Created by Henry Yu on 6/4/10.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <UIKit/UIKit.h>

@class SlideshowView;
@class SlideshowViewController;
@interface PageViewController : UIViewController
{
	int pageId;
	int parentType;
	NSInteger pageIndex;
	BOOL textViewNeedsUpdate;
	IBOutlet UILabel *label;
	
	SlideshowViewController *managingViewController;
	SlideshowView *slideshowView;	
}

@property int pageId;
@property NSInteger pageIndex;
@property (nonatomic, retain) SlideshowViewController *managingViewController;

- (id)initWithParentViewController:(SlideshowViewController *)aViewController Type:(int)t;
- (void)updateDatas:(int)index fromType:(int)t;
- (void)updateTextViews:(BOOL)force;
- (void)setBackgroundColorbyIndex:(int)index;
- (NSArray *)getSortedSeries;
- (int)getCurrentOffset;
- (void)setBigThumbPhoto:(UIImage *)photo atIndex:(int)index type:(int)t;
- (void)playVideo:(NSString *)file;
- (void)scrolledToIndex:(int)index;
- (void)showFullScreenPhoto:(NSString *)filename;
- (int)indicatorAtArray:(int)index;
- (void)indicatorArraySet:(int)index Value:(int)v;
- (void)resetPageOrder;

//===
- (void)resetData;
- (void)setNumberOfPhotos:(int)n;
- (void)setPhoto:(UIImage *)photo atIndex:(int)index Location:(NSString *)location;
- (void)showPhotoAtIndex:(int)index;
- (void)adjustStrangeScap;

@end

