//
//  GradientView.m
//  Palette
//
//  Created by Henry Yu on 10-11-15.
//  Copyright Sevenuc.com 2010. All rights reserved.
//


#import "GradientView.h"


@implementation GradientView

@synthesize theColor;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


// Returns an appropriate starting point for the demonstration of a linear gradient
CGPoint demoLGStart(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}

// Returns an appropriate ending point for the demonstration of a linear gradient
CGPoint demoLGEnd(CGRect bounds)
{
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}

- (void) setupGradient { 
	
	const CGFloat *c = CGColorGetComponents(theColor);
	CGFloat colors[] =
	{
		255.0/255.0,255.0/255.0,255.0/255.0,1.0, //WHITE
		
		c[0],c[1],c[2],1.00, //THE COLOR
		
		0.0/255.0,0.0/255.0,0.0/255.0,1.0, //BLACK
	};
	
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	
	gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);
	
	
}


- (void)drawRect:(CGRect)rect {
    // Drawing code

	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// The clipping rects we plan to use, which also defines the locations of each gradient
	CGRect clips[] =
	{
		CGRectMake(0.0, 0.0, 300.0, 60.0),
		//self.frame,
	};
	
	CGPoint points[] =
	{
		CGPointMake(0,0),
		CGPointMake(300,0),
	};
	// Linear Gradients
	CGPoint start, end;
	
	// Clip to area to draw the gradient, and draw it. Since we are clipping, we save the graphics state
	// so that we can revert to the previous larger area.
	CGContextSaveGState(context);
	CGContextClipToRect(context, clips[0]);
	
	start = points[0];
	end = points[1];
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);
}


- (void)dealloc {
	CGGradientRelease(gradient);
    [super dealloc];
}


@end
