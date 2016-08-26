//
//  ThumbsView.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "ThumbsView.h"
#import "ThumbsViewController.h"
#import "LayoutManagers.h"
#import "TouchableView.h"

#define THUMB_WIDTH 65
#define THUMB_HEIGHT 89
#define THUMB_SPACING 4
#define SPINNER_WIDTH 10
#define ROW_THUMBS    14


@implementation ThumbsView

- (id)initWithFrame:(CGRect)frame controller:(ThumbsViewController *)c
{
    if (self = [super initWithFrame:frame])
    {
        controller = c;
        self.contentSize = frame.size;
		self.scrollEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc
{
    [photoContainers release];
    [mainLayout release];
    [super dealloc];
}

- (void)setNumberOfPhotos:(int)n
{
	int screenWidth =  1024; 

	int kNumberOfPages = n/(ROW_THUMBS*7);
	if(n%(ROW_THUMBS*7) > 0){
		kNumberOfPages++;
	}
	
	self.contentSize = CGSizeMake(self.frame.size.width,
								  self.frame.size.height*kNumberOfPages+200);
	
    [mainLayout removeFromSuperview];
    [mainLayout release];
    mainLayout = [[VLayoutView alloc]
                  initWithFrame:controller.innerFrame
                  spacing:THUMB_SPACING
                  leftMargin:THUMB_SPACING rightMargin:THUMB_SPACING
                  topMargin:THUMB_SPACING+22 bottomMargin:THUMB_SPACING
                  hAlignment:UIControlContentHorizontalAlignmentLeft
                  vAlignment:UIControlContentVerticalAlignmentTop];
    mainLayout.scrollEnabled = YES;
    mainLayout.clipsToBounds = NO;
    [self addSubview:mainLayout];
    [photoContainers release];
    photoContainers = [[NSMutableArray alloc] initWithCapacity:n];
    HLayoutView *rowLayout;
    for (int i = 0; i < n; ++i)
    {
        if ((i % ROW_THUMBS) == 0)
        {
            rowLayout = [[HLayoutView alloc] initWithFrame:
                         CGRectMake(0, 0, 
									screenWidth,
			                       /*THUMB_WIDTH * ROW_THUMBS + THUMB_SPACING * (ROW_THUMBS-1)*/
                                    THUMB_HEIGHT)
                         spacing:THUMB_SPACING
                         leftMargin:0 rightMargin:0 topMargin:0 bottomMargin:0
                         hAlignment:UIControlContentHorizontalAlignmentLeft
                         vAlignment:UIControlContentVerticalAlignmentTop];
            [mainLayout addSubview:rowLayout];
            [rowLayout release];
        }
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  [NSNumber numberWithInt:i] forKey:@"index"];
        TouchableView *container = [[TouchableView alloc] initWithFrame:
                                    CGRectMake(0, 0, THUMB_WIDTH, THUMB_HEIGHT)
                                    target:self userInfo:userInfo];
        container.touchesEndedSelector = @selector(thumbTapped:);
        [rowLayout addSubview:container];
        [container release];
        [container addSubview:[self loadingIndicatorView]];
        [photoContainers addObject:container];
    }
}

- (void)setPhoto:(UIImage *)photo atIndex:(int)index
{
    UIView *photoContainer = [photoContainers objectAtIndex:index];
    UIView *loadingIndicator = [photoContainer.subviews lastObject];
    [loadingIndicator removeFromSuperview];
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:
    //                          CGRectMake(0, 0, THUMB_WIDTH, THUMB_HEIGHT)];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 0, photo.size.width, photo.size.height)];
    imageView.image = photo;
    [photoContainer addSubview:imageView];
    [imageView release];
}

- (UIView *)loadingIndicatorView
{
    UIActivityIndicatorView *spinner
        = [[UIActivityIndicatorView alloc] initWithFrame:
           CGRectMake((THUMB_WIDTH - SPINNER_WIDTH) / 2,
                      (THUMB_WIDTH - SPINNER_WIDTH) / 2,
                      SPINNER_WIDTH, SPINNER_WIDTH)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [spinner startAnimating];
    return [spinner autorelease];
}

- (void)thumbTapped:(NSDictionary *)userInfo
{
    [controller thumbTapped:[[userInfo objectForKey:@"index"] intValue]];
}

@end
