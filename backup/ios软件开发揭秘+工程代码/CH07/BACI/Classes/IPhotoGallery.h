//  IPhotoGallery.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "ThumbsViewControllerDelegate.h"
#import "SlideshowViewControllerDelegate.h"
#import "VideoPlayViewController.h"

@protocol IPhotoGalleryDelegate;
@class ThumbsViewController;
@class SlideshowViewController;

@interface IPhotoGallery : UINavigationController
    <ThumbsViewControllerDelegate, SlideshowViewControllerDelegate>
{
    id<IPhotoGalleryDelegate> iPhotoGalleryDelegate;
	VideoPlayViewController* videoViewController;
    ThumbsViewController *thumbsViewController;
    SlideshowViewController *slideshowViewController;
	SlideshowViewController *slideshowViewController2;
	SlideshowViewController *slideshowViewController3;
	int savedSeriesId;
	BOOL firstLoad;
}

@property BOOL firstLoad;
@property int savedSeriesId;

- (id)initWithDelegate:(id<IPhotoGalleryDelegate>)delegate;
- (BOOL)findViewControllerByTag:(int)tag;
- (void)reloadData;
- (void)resetAllViews;
- (void)fetchedPhotoThumb:(UIImage *)photo atIndex:(int)index;
- (void)fetchedPhoto:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location;
- (void)fetchedPhoto2:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location;
- (void)fetchedPhoto3:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location;
- (void)fetchedBigThumb:(UIImage *)photo atIndex:(int)index atPage:(int)page type:(int)t;

- (void)showSeries:(int)index ReLoad:(BOOL)reload;
- (void)showSeriesDetailView:(int)index fromType:(int)t;
- (void)showBigPicture:(int)index fromType:(int)t;
- (void)showThumbView:(int)index;


@end
