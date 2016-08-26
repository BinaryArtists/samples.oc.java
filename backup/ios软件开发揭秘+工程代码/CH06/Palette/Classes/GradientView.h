//
//  GradientView.m
//  Palette
//
//  Created by Henry Yu on 10-11-15.
//  Copyright Sevenuc.com 2010. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface GradientView : UIView {
	CGGradientRef gradient;
	CGColorRef theColor;
}

@property (readwrite) CGColorRef theColor;
- (void) setupGradient;
@end
