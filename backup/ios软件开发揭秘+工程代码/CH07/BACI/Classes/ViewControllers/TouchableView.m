//
//  TouchableView.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
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
        
        selectionOverlay = [[UIView alloc] initWithFrame:self.bounds];        
		selectionOverlay.backgroundColor = [UIColor clearColor];
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
	[self addSubview:selectionOverlay];
	
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
