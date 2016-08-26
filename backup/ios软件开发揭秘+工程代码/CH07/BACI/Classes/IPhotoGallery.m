//  IPhotoGallery.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "IPhotoGallery.h"
#import "IPhotoGalleryDelegate.h"
#import "ThumbsViewController.h"
#import "SlideshowViewController.h"
#import "Constants.h"
#import "BACIAppDelegate.h"

@implementation IPhotoGallery

@synthesize firstLoad;
@synthesize savedSeriesId;

- (id)initWithDelegate:(id<IPhotoGalleryDelegate>)delegate
{
    
	if (self = [super init])
    {
	    iPhotoGalleryDelegate = [delegate retain];
		videoViewController = nil;
		firstLoad = TRUE;
		savedSeriesId = 0;
		
		thumbsViewController = [[ThumbsViewController alloc] 
								   initWithNibName:@"ThumbsViewController" bundle:nil];
		
		thumbsViewController.view.tag = kTagThumbView;
		[thumbsViewController setDelegate:self];
		
		
		slideshowViewController = [[SlideshowViewController alloc] 
								   initWithNibName:@"SlideshowViewController" bundle:nil];
		slideshowViewController2 = [[SlideshowViewController alloc] 
									initWithNibName:@"SlideshowViewController" bundle:nil];
		slideshowViewController3 = [[SlideshowViewController alloc] 
									initWithNibName:@"SlideshowViewController" bundle:nil];
		
				
		[slideshowViewController setDelegate:self Type:SLIDESHOW_SERIES];
		[slideshowViewController2 setDelegate:self Type:SLIDESHOW_SERIESDETAILS];
		[slideshowViewController3 setDelegate:self Type:SLIDESHOW_BIGPICTURE];
		slideshowViewController.view.tag = kTagSeriesView;
		slideshowViewController2.view.tag = kTagSeriesDetailView;
		slideshowViewController3.view.tag = kTagBigpictureView;		

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle
	     = UIStatusBarStyleBlackOpaque;
    self.navigationBar.translucent = YES;
	self.navigationBar.barStyle = UIBarStyleBlack;
    self.toolbar.translucent = NO;
    self.toolbar.barStyle = UIBarStyleBlack;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.toolbar.translucent = NO;
    self.toolbar.barStyle = UIBarStyleDefault;
}

- (void)dealloc
{
    [slideshowViewController release];
	[slideshowViewController2 release];
	[slideshowViewController3 release];
    [thumbsViewController release];
    [iPhotoGalleryDelegate release];
	if(videoViewController != nil)
		videoViewController = nil;
    [super dealloc];
}


- (BOOL)findViewControllerByTag:(int)tag{
	BOOL found = FALSE;
	
	int i, count = [self.viewControllers count];
	
	for( i = 0; i< count; i++){		
		UIViewController *controller = [self.viewControllers objectAtIndex:i];		
		if(controller.view.tag == tag){			
			found = TRUE;
			[controller viewWillAppear:YES];
			[self.view addSubview:controller.view];
			[controller viewDidAppear:NO];
			[self.view bringSubviewToFront:controller.view];
			break;
		}
	}
	return found;
}

#pragma mark public controllers
- (void)showSeries:(int)sId ReLoad:(BOOL)reload{
	int index = sId;
#if	OPTIMAZE_PAGING
	index = index+[slideshowViewController getCurrentOffset]*3;
#endif
	
	if(reload){
		NSLog(@"showSeries: reload %d",index);
		index = 0;
	    [self reloadData];
	}		
			
	[slideshowViewController showPhotoAtIndex:index];
	BOOL found = [self findViewControllerByTag:kTagSeriesView];
	if(!found){
		[self pushViewController:slideshowViewController animated:YES];
	}	
	
}

- (void)showSeriesDetailView:(int)index fromType:(int)t{
		
	BACIAppDelegate* appDelegate =
	    (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	BOOL showFirst = FALSE;	
	int iIndex = index;
	if(t == kTagThumbView){	
		//
	}else if(t == kTagBigpictureView){	
		iIndex = appDelegate.savedSeriesDetailIndex;
		NSLog(@"showSeriesDetailView,from big back,savedSeriesId:%d",iIndex);
		if(iIndex < 3){
			iIndex = 0;
			showFirst = TRUE;
		}		
	}else if(t == kTagSeriesView){
		iIndex = 0;
		appDelegate.currentSeries = index;
		
		slideshowViewController2.sereisNameIndex = index;
		
		if(savedSeriesId != index||firstLoad){
			showFirst = TRUE;
			if(firstLoad){			
				firstLoad = FALSE;
			}
			NSLog(@"＊＊＊showSeriesDetailView:%d reloadData",index);
			[slideshowViewController2 reloadData];
			[slideshowViewController3 reloadData];
			[thumbsViewController reloadData];
		}
		savedSeriesId = index;
	}	
	
	[slideshowViewController2 showPhotoAtIndex:iIndex];
	BOOL found = [self findViewControllerByTag:kTagSeriesDetailView];
	if(!found){
		
		[self pushViewController:slideshowViewController2 animated:YES];
		[self.view bringSubviewToFront:slideshowViewController2.view];
	}
	
	[slideshowViewController2 adjustLastPageFromBigView:iIndex];
	
	if(showFirst){
		[slideshowViewController2 showFirstPage];
	}
		
}

- (void)showBigPicture:(int)index fromType:(int)t
{
	slideshowViewController3.fromBigType = t;	
	#if	OPTIMAZE_PAGING
		if(t == kTagSeriesDetailView||t == kTagThumbView){
			NSLog(@"IPhotoGallery,showBigPicture:%d",index);
			[slideshowViewController3 reloadData2:index];		
		}
    #else
	   [slideshowViewController3 showPhotoAtIndex:index];
    #endif	
	BOOL found = [self findViewControllerByTag:kTagBigpictureView];
	if(!found){
      [self pushViewController:slideshowViewController3 animated:YES];
	}	
}

- (void)showThumbView:(int)index{
	
	BOOL found = [self findViewControllerByTag:kTagThumbView];
	if(!found){
        [self pushViewController:thumbsViewController animated:YES];
		[self.view bringSubviewToFront:thumbsViewController.view];
	}	
}

#pragma mark Public

- (void)reloadData
{
	
	savedSeriesId = 0;
	[thumbsViewController reloadData];
    [slideshowViewController reloadData];
	[slideshowViewController2 reloadData];
	[slideshowViewController3 reloadData];
}

- (void)resetAllViews{
	[thumbsViewController resetAllViews];
    [slideshowViewController resetAllViews];
	[slideshowViewController2 resetAllViews];
	[slideshowViewController3 resetAllViews];
}

- (void)fetchedPhotoThumb:(UIImage *)photo atIndex:(int)index
{
    [thumbsViewController fetchedPhoto:photo atIndex:index];
}

- (void)fetchedBigThumb:(UIImage *)photo atIndex:(int)index atPage:(int)page type:(int)t{
	[slideshowViewController3 fetchedBigThumb:photo atIndex:index atPage:page type:t];	
}

- (void)fetchedPhoto:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location
{
    [slideshowViewController fetchedPhoto:photo atIndex:index atPage:page Location:location];	
}

- (void)fetchedPhoto2:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location
{
 	[slideshowViewController2 fetchedPhoto:photo atIndex:index atPage:page Location:location];
}

- (void)fetchedPhoto3:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location
{
 	[slideshowViewController3 fetchedPhoto:photo atIndex:index atPage:page Location:location];
}

#pragma mark ThumbsViewControllerDelegate

- (int)thumbsViewControllerPhotosCount:(ThumbsViewController *)tvc
{
    return [iPhotoGalleryDelegate iPhotoGalleryPhotosCount:self ControllerType:SLIDESHOW_THUMBS];	
}

- (void)thumbsViewController:(ThumbsViewController *)tvc
    fetchPhotoAtIndex:(int)index Location:(NSString *)location
{
    [iPhotoGalleryDelegate iPhotoGallery:self fetchPhotoThumbAtIndex:index Location:location];
}

- (void)thumbsViewController:(ThumbsViewController *)tvc
    selectedPhotoAtIndex:(int)index
{
	
#if THUM_TO_DETAIL	
	[slideshowViewController2 showPhotoAtIndex:index];
	[self showSeriesDetailView:index fromType:kTagThumbView];
#endif	
	
	[self showBigPicture:index fromType:kTagThumbView];
	
}

#pragma mark SlideshowViewControllerDelegate
- (int)slideshowViewControllerPhotosCount:(SlideshowViewController *)svc ControllerType:(int)t
{
    return [iPhotoGalleryDelegate iPhotoGalleryPhotosCount:self ControllerType:t];
	
}

- (void)slideshowViewController:(SlideshowViewController *)svc
    fetchPhotoAtIndex:(int)index Location:(NSString *)location Type:(int)t Page:(int)p
{
    [iPhotoGalleryDelegate iPhotoGallery:self fetchPhotoAtIndex:index Location:location Type:t Page:p];
}

@end
