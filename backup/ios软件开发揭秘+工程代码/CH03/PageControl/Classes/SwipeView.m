//
//  SwipeView.m
//  PageControl
//
//  Created by Henry Yu on 10-11-17.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SwipeView.h"


@implementation SwipeView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void) setHost: (UIViewController *) aHost
{
	host = aHost;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
	UITouch *touch = [touches anyObject]; 
	startTouchPosition = [touch locationInView:self]; 
	dirString = NULL;
} 

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{ 
	UITouch *touch = touches.anyObject; 
	CGPoint currentTouchPosition = [touch locationInView:self]; 
	
#define HORIZ_SWIPE_DRAG_MIN 12 
#define VERT_SWIPE_DRAG_MAX 4 
	
	if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= 
		HORIZ_SWIPE_DRAG_MIN && 
		fabsf(startTouchPosition.y - currentTouchPosition.y) <= 
		VERT_SWIPE_DRAG_MAX) 
	{ 
		// Horizontal Swipe
		if (startTouchPosition.x < currentTouchPosition.x) {
			dirString = kCATransitionFromLeft;
		}
		else 
			dirString = kCATransitionFromRight;
	}
} 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if (dirString) [host swipeTo:dirString];
}


@end
