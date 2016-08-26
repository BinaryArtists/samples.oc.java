//
//  TouchableView.m
//  MultiTouch
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "TouchableView.h"
#import "TouchableView+Private.h"
#include <execinfo.h>
#include <stdio.h>

@implementation TouchableView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame] == nil) {
        return nil;
    }

    originalTransform = CGAffineTransformIdentity;
    touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.exclusiveTouch = YES;

    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }
    [self cacheBeginPointForTouches:touches];
	[delegate touchDragBegin];	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
    self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
	[delegate touchDragMove];	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount >= 2) {
            [self.superview bringSubviewToFront:self];
        }
    }

    [self updateOriginalTransformForTouches:[event touchesForView:self]];
    [self removeTouchesFromCache:touches];

    NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [remainingTouches minusSet:touches];
    [self cacheBeginPointForTouches:remainingTouches];
	
	NSLog(@"center:%.2f %.2f",self.center.x,self.center.y);
	[delegate touchDragEnd];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
	[delegate touchDragCancel];
}

- (void)dealloc
{
    CFRelease(touchBeginPoints);
    
    [super dealloc];
}

@end
