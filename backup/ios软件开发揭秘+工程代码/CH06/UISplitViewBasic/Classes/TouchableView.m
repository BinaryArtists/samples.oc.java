//
//  TouchableView.m
//  UISplitViewBasic
//
//  Created by Henry Yu on 5/18/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "TouchableView.h"

@implementation TouchableView

@synthesize touchesBeganSelector;
@synthesize touchesMovedSelector;
@synthesize touchesEndedSelector;
@synthesize touchesCancelledSelector;

- (id)initWithFrame:(CGRect)frame target:(id)_target
    userInfo:(NSDictionary *)_userInfo
{
    if (self = [super initWithFrame:frame])
    {
        target = [_target retain];
        userInfo = [_userInfo retain];
		
        self.backgroundColor = [UIColor redColor];
		
        selectionOverlay = [[UIView alloc] initWithFrame:self.bounds];
        //selectionOverlay.backgroundColor = [UIColor colorWithRed:0 green:0
        //                                    blue:0 alpha:0.3];
		selectionOverlay.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)dealloc
{
    [selectionOverlay release];
    [userInfo release];
    [target release];
    [super dealloc];
}

#pragma mark UIResponder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint gestureStartPoint = [touch locationInView:self];
    NSLog(@"test x:%f",gestureStartPoint.x);
    NSLog(@"test y:%f",gestureStartPoint.y);
    	
    [self addSubview:selectionOverlay];
	//[self bringSubviewToFront:selectionOverlay];
    if ([target respondsToSelector:touchesBeganSelector])
        [target performSelector:touchesBeganSelector withObject:userInfo];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([target respondsToSelector:touchesMovedSelector])
        [target performSelector:touchesMovedSelector withObject:userInfo];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [selectionOverlay removeFromSuperview];
    if ([target respondsToSelector:touchesEndedSelector])
        [target performSelector:touchesEndedSelector withObject:userInfo];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [selectionOverlay removeFromSuperview];
    if ([target respondsToSelector:touchesCancelledSelector])
        [target performSelector:touchesCancelledSelector withObject:userInfo];
}

@end
