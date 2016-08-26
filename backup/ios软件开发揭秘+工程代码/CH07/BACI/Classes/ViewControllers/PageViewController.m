//
//  PageViewController.m
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

#import "PageViewController.h"
#import "DataSource.h"
#import <QuartzCore/QuartzCore.h>

#import "SlideshowView.h"
#import "IPhotoGallery.h"
#import "BACIAppDelegate.h"
#import "Constants.h"
#import "SlideshowViewController.h"

const CGFloat TEXT_VIEW_PADDING = 10.0;

@implementation PageViewController

@synthesize pageId;
@synthesize pageIndex;
@synthesize managingViewController;

- (id)initWithParentViewController:(SlideshowViewController *)aViewController Type:(int)t{
    if (self = [super initWithNibName:@"PageViewController" bundle:nil]) {
        self.managingViewController = aViewController; 
		parentType = t;
    }
    return self;
}


- (void)loadView
{
	[super loadView];
	int screenWidth = 1024, screenHeight = 768;
	
if(parentType == SLIDESHOW_SERIES){		
	slideshowView = [[SlideshowView alloc]
                     initWithFrame:CGRectMake(-20, 0, screenWidth, screenHeight)
                     controller:self Type:parentType];
}else{
	slideshowView = [[SlideshowView alloc]
                     initWithFrame:CGRectMake(-10, 0, screenWidth, screenHeight)
                     controller:self Type:parentType];
}
	
#if SHOW_BACI_BACKGROUND
	
	UIImageView *background = [[UIImageView alloc]initWithImage:
							   [UIImage imageNamed:@"592x1024.jpg"]];
	background.backgroundColor=[UIColor clearColor];
	background.frame = CGRectMake(0, 22, screenWidth, screenHeight-44);
	[slideshowView addSubview: background];			//add the background to our mainview
	[slideshowView sendSubviewToBack:background];	//move the background view to the back of UIWebView
	[background release];
	 
#endif
	
	[self.view addSubview:slideshowView];
	
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];	
	
}

- (void)setBackgroundColorbyIndex:(int)index{
	switch(index %7){
		case 1:
			self.view.backgroundColor = [UIColor yellowColor];
			break;
		case 2:
			self.view.backgroundColor = [UIColor magentaColor];
			break;
		case 3:
			self.view.backgroundColor = [UIColor orangeColor];
			break;
		case 4:
			self.view.backgroundColor = [UIColor purpleColor];
			break;
		case 5:
			self.view.backgroundColor = [UIColor redColor];
			break;
		case 6:
			self.view.backgroundColor = [UIColor greenColor];
		case 7:
			self.view.backgroundColor = [UIColor blueColor];
			break;
		case 8:
			self.view.backgroundColor = [UIColor whiteColor];
			break;
		case 9:
			self.view.backgroundColor = [UIColor purpleColor];
			break;
		default:
			self.view.backgroundColor = [UIColor cyanColor];
	}
}

- (void)setPageIndex:(NSInteger)newPageIndex
{
	pageIndex = newPageIndex;

#if !SHOW_BACI_BACKGROUND
	int t = pageIndex;
	[self setBackgroundColorbyIndex:t];
#endif
	
	label.text = [[DataSource sharedDataSource] dataForPage:pageIndex];
	
	//if (pageIndex >= 0 && pageIndex < [[DataSource sharedDataSource] numDataPages])
	{
		CGRect absoluteRect = [self.view.window
			convertRect:slideshowView.bounds
			fromView:slideshowView];
		if (!self.view.window ||
			!CGRectIntersectsRect(
				CGRectInset(absoluteRect, TEXT_VIEW_PADDING, TEXT_VIEW_PADDING),
				[self.view.window bounds]))
		{
			textViewNeedsUpdate = YES;
		}		
	}
}

- (void)updateDatas:(int)index fromType:(int)t
{
	//NSLog(@"updateDatas:%d",index);
	NSLog(@"updateDatas, current:%d me:%d", index,self.pageIndex);
	//
	
}

- (void)updateTextViews:(BOOL)force
{
	/*
	if (force ||
		(textViewNeedsUpdate &&
		self.view.window &&
		CGRectIntersectsRect(
			[self.view.window
				convertRect:CGRectInset(slideshowView.bounds, 
						TEXT_VIEW_PADDING, TEXT_VIEW_PADDING)
				fromView:slideshowView],
			[self.view.window bounds])))
		*/
	if (force)
	{
		NSLog(@"updateTextViews:%d",self.pageIndex);
		for (UIView *childView in slideshowView.subviews)
		{
			[childView setNeedsDisplay];
		}
		textViewNeedsUpdate = NO;
	}
	
}

#pragma mark view calles
- (void)resetData{
	[slideshowView resetData];
}

- (void)resetPageOrder{
	[managingViewController resetPageOrder];
}

-(NSArray *)getSortedSeries{
	return [managingViewController getSortedSeries];
}

- (int)getCurrentOffset{
	return [managingViewController getCurrentOffset];
}

- (void)setNumberOfPhotos:(int)n{
	
	[slideshowView setNumberOfPhotos:n];
	
}

- (void)setPhoto:(UIImage *)photo atIndex:(int)index Location:(NSString *)location{
	//int left = index%3;	
	[slideshowView setPhoto:photo atIndex:index Location:location];
}

- (void)showPhotoAtIndex:(int)index{
		
	[slideshowView showPhotoAtIndex:index];
}

- (void)adjustStrangeScap{
	if(parentType == SLIDESHOW_SERIES){
		BACIAppDelegate* appDelegate = 
		(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
		if(appDelegate.mainMenu == CATEGORIES){
			
			slideshowView.frame = CGRectMake(30, 0, 1024, 768-44);
		}		
	}
}

- (void)indicatorArraySet:(int)index Value:(int)v{
	[managingViewController indicatorArraySet:index Value:v];
}

- (int)indicatorAtArray:(int)index{
	return [managingViewController indicatorAtArray:index];
}

- (void)setBigThumbPhoto:(UIImage *)photo atIndex:(int)index type:(int)t{
	[slideshowView setBigThumbPhoto:photo atIndex:index type:t];
}

- (void)playVideo:(NSString *)file{
	[managingViewController playVideo:file];
}

- (void)scrolledToIndex:(int)index{
	[managingViewController scrolledToIndex:index];
}

- (void)showFullScreenPhoto:(NSString *)filename{
	[managingViewController showFullScreenPhoto:filename];
}

@end

