    //
//  PageViewController.m
//  PageControl
//
//  Created by Henry Yu on 10-11-17.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "PageViewController.h"
#import "SwipeView.h"

@implementation PageViewController

- (id)init
{
	if (!(self = [super init])) return self;
	self.title = @"WallPaper Show";
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[contentView release];
    [super dealloc];
}



- (CATransition *) getAnimation:(NSString *) direction
{
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setType:kCATransitionPush];
	[animation setSubtype:direction];
	[animation setDuration:1.0f];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	return animation;
}

- (void) pageTurn: (UIPageControl *) pageControl
{
	CATransition *transition;
	int secondPage = [pageControl currentPage];
	if ((secondPage - currentPage) > 0)
		transition = [self getAnimation:@"fromRight"];
	else
		transition = [self getAnimation:@"fromLeft"];
	
	UIImageView *newView = (UIImageView *)[[contentView subviews] objectAtIndex:0];
	[newView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipad_wallpaper%02d.jpg", secondPage + 1]]];
	[contentView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[[contentView layer] addAnimation:transition forKey:@"transitionViewAnimation"];
	
	currentPage = [pageControl currentPage];
}

- (void) swipeTo: (NSString *) aDirection
{
	UIPageControl *pageControl = [[[contentView superview] subviews] lastObject];
	
	if ([aDirection isEqualToString:kCATransitionFromRight])
	{
		if (currentPage == 5) return;
		[pageControl setCurrentPage:currentPage + 1];
	} else {
		if (currentPage == 0) return;
		[pageControl setCurrentPage:currentPage - 1];
	}
	
	[self pageTurn:pageControl];
}

- (void)loadView
{
	//CGRect frame = [[UIScreen mainScreen] applicationFrame];
	CGRect frame =  CGRectMake(0, 0, 320, 480);
	
	// Load an application image and set it as the primary view
	UIView *baseView = [[UIView alloc] initWithFrame:frame];
	
	// Add the content view with its two images
	contentView = [[SwipeView alloc] initWithFrame:frame];
	[contentView setHost:self];
	[contentView addSubview:[[UIImageView alloc] initWithFrame:frame]];
	[contentView addSubview:[[UIImageView alloc] initWithFrame:frame]];
	for (UIView *view in [contentView subviews])
		[view setUserInteractionEnabled:NO];
	
	[[[contentView subviews] lastObject] setImage:[UIImage imageNamed:@"ipad_wallpaper03.jpg"]];
	
	[baseView addSubview:contentView];
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
	
	UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, 20.0f, bounds.size.width, 20.0f)];
	[pageControl setNumberOfPages:6];
	[pageControl setCurrentPage:(currentPage = 2)];
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
	[baseView addSubview:pageControl];
	self.view = baseView;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{	
	if((fromInterfaceOrientation == UIInterfaceOrientationPortrait) ||
	   (fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)){    
		//CGRect bounds = self.view.bounds;
		CGRect bounds =  CGRectMake(0, 0, 480, 320);
		self.view.frame = bounds;	
		for (UIView *view in [contentView subviews])
			view.frame = bounds;	
	}else{
		CGRect bounds =  CGRectMake(0, 0, 320, 480);
		self.view.frame = bounds;
		for (UIView *view in [contentView subviews])
			view.frame = bounds;
	}
}


@end
