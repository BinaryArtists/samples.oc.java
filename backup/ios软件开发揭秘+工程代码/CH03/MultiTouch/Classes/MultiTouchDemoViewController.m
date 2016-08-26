//
//  MultiTouchDemoAppDelegate.m
//  MultiTouch
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "MultiTouchDemoViewController.h"
#import "TouchableView.h"
#import "UIView+Hierarchy.h"

#define IMAGE_WIDTH 200.0

@implementation MultiTouchDemoViewController

- (void)slideShow:(id)sender{
	UIView *view = nil, *view2 = nil;
	for(view in [self.view subviews]){
		if([view isKindOfClass:[TouchableView class]]){
			if(view2 == nil){
				view2 = view;
				continue;
			}
			
			[UIView beginAnimations:@"positionChange" context:nil];
			[UIView setAnimationDuration:0.5];
						
			CGPoint temp = view.center;
			view.center = view2.center;
			view2.center = temp;			
		    [view2 swapDepthsWithView:view];
			
			[UIView commitAnimations];					   
		}
	} 	
}

- (void)onClick{
	NSString *title = @"Shuffle";
	if(timer == nil){
		title = @"Stop";		
	}
	UIButton *button = (UIButton *)[[toolbar.items objectAtIndex:1] customView];
	[button setSelected:YES];
	[button setTitle: title forState: UIControlStateNormal];   
	
	if(timer == nil){
		UIView *mix = [self.view viewWithTag:105];
		[self.view bringSubviewToFront:mix];
		timer =  [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self 
					 selector:@selector(slideShow:) userInfo:nil repeats:YES];
	}else{
		[timer invalidate];
		timer = nil;
	}	
}

- (void)createToolBar{

	CGRect bounds = [[UIScreen mainScreen] bounds];
	toolbar = [[UIToolbar alloc] initWithFrame:
						  CGRectMake(0, bounds.size.height-40, bounds.size.width, 20)];
		
	CGRect buttonFrame = CGRectMake( 0, 0, 320, 30 );
	UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
	[button setTitle: @"Shuffle" forState: UIControlStateNormal];
	[button setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];	
	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	[button setShowsTouchWhenHighlighted:YES];
	button.titleLabel.font = [UIFont fontWithName:@"Arial" size: 12];
	[button addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
			
	UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem: 
								  UIBarButtonSystemItemFlexibleSpace
								  target:nil action:nil];
	UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:
								   UIBarButtonSystemItemFlexibleSpace
								   target:nil action:nil];
	
	NSArray *newItems = [NSArray arrayWithObjects:leftSpace, buttonItem,rightSpace,nil];
	[toolbar setItems:newItems];
	[button release];
	[buttonItem release];	
	[leftSpace release];	
	[rightSpace release];
	toolbar.translucent = NO;
    
    [self.view addSubview:toolbar];
	[self.view bringSubviewToFront:toolbar];
	
}


- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
	 
	for(int i = 0; i < 10; i++){
		int j = i+1;
		UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%02d.jpg",j]];
		CGRect imageRect = CGRectMake(0.0, 0.0, IMAGE_WIDTH, 0.0);
		imageRect.size.height = IMAGE_WIDTH * image.size.height / image.size.width;
		TouchableView *touchImageView = [[TouchableView alloc] initWithFrame:imageRect];
		touchImageView.tag = 100+i;
		touchImageView.image = image;
		touchImageView.center = CGPointMake(120.0+8*i, 85.0+18*i);
		[self.view addSubview:touchImageView];
		[touchImageView release];
	}	

	[self createToolBar];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
