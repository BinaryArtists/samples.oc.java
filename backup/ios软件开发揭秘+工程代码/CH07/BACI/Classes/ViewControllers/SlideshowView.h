//
//  SlideshowView.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

@class HLayoutView;
@class PageViewController;

@interface SlideshowView : UIView <UIScrollViewDelegate>
{
	int controllerType;    
	PageViewController *controller;
    HLayoutView *mainLayout;
    NSMutableArray *photoContainers; 
	UIImageView *tmpImageView;
	NSInteger thumbIndex;
	BOOL isBlack;
	int currentIndex;
	int numberOfPhoto;
	int boundsSizeWidth;
	SEL reloadDataSelector;	
	int savedIndicatorX,savedIndicatorY;	
}

@property int controllerType;
@property (nonatomic, retain) PageViewController *controller;
@property NSInteger thumbIndex;
@property int currentIndex;
@property int numberOfPhoto;
@property int boundsSizeWidth;
@property int savedIndicatorX,savedIndicatorY;

- (id)initWithFrame:(CGRect)frame controller:(PageViewController *)c Type:(int)t;
- (void)resetData;
- (UIView *)findSubViewByTag:(UIView *)parent Tag:(int)t;
- (void)setNumberOfPhotos:(int)n;
- (void)setPhoto:(UIImage *)photo atIndex:(int)index Location:(NSString *)location;
- (void)showPhotoAtIndex:(int)index;
- (void)setBigThumbPhoto:(UIImage *)photo atIndex:(int)index type:(int)t;

- (UIView *)loadingIndicatorView;
- (void)thumbTapped:(id)sender event:(id)event;
-(UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end

