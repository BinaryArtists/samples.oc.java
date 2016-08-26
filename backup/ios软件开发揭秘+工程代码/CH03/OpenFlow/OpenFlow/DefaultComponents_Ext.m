//
//  DefaultComponents_Ext.m
//  mTime
//
//  Created by Alan Liu on 11/5/09.
//  Copyright 2009 illusionfans. All rights reserved.
//

#import "DefaultComponents_Ext.h"


@implementation UINavigationBar (MTimeNavigationBar)

- (void)drawRect:(CGRect)rect {
	/*
	NSLog(@"superview:%f",self.superview.frame.size.width);
	
	NSArray *windows = [[UIApplication sharedApplication] windows];
    if ([windows count] > 1){
		UIWindow *win = [[UIApplication sharedApplication] keyWindow];
		NSLog(@"width:%d",[[UIApplication sharedApplication] statusBarOrientation]);
        return;
    }
	
	if([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait){
	    // Drawing code	
		UIImage *img = [UIImage imageNamed: @"navbar_bg.png"];
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextDrawImage(context, CGRectMake(0, 0, 320, self.frame.size.height), img.CGImage);
	}
	 */
	/*
	if(self.superview.frame.size.width > 320){
		self.barStyle = UIBarStyleBlack;
		[super drawRect:rect];
		return;
	}*/
	
	// Drawing code	
	UIImage *img = [UIImage imageNamed: @"navbar_bg.png"];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0, 0, self.frame.size.width,self.frame.size.height), img.CGImage);
}
@end

@implementation UIToolbar (MTimeToolbar)

- (void)drawRect:(CGRect)rect {
    // Drawing code	
	UIImage *img = [UIImage imageNamed: @"toolbar_bg.png"];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0, 0, 320, self.frame.size.height), img.CGImage);
	
}
@end

@implementation UIImage(MTimeImage)

- (UIImage*)imageWithBorderWidth:(CGFloat)width{
	
	CGSize size = [self size];
	UIGraphicsBeginImageContext(size);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetRGBStrokeColor(context, 0.54, 0.59, 0.63, 1.0); 
	CGContextStrokeRectWithWidth(context, rect, width);
	UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return testImg;
}

void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight, UIImageCornerPosition position){
	
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
	if (UIImageCornerPositionTop == position) {
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
		CGContextAddLineToPoint(context, 0, 0);
		CGContextAddLineToPoint(context, fw, 0);
	}else if (UIImageCornerPositionBottom == position) {
		CGContextMoveToPoint(context, 0, fh/2);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
		CGContextAddLineToPoint(context, fw, fh);
		CGContextAddLineToPoint(context, 0, fh);
	}else if (UIImageCornerPositionTop|UIImageCornerPositionBottom == position) {
		CGContextMoveToPoint(context, fw, fh/2);
		CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
		CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
		CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
		CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	}

	CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)imageWithRoundCornerWidth:(int)cornerWidth Height:(int)cornerHeight Position:(UIImageCornerPosition)position{
	
	UIImage * newImage = nil;
	
	if( nil != self){
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		int w = self.size.width;
		int h = self.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight, position);
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		newImage = [[UIImage imageWithCGImage:imageMasked] retain];
		CGImageRelease(imageMasked);
		
		[pool release];
	}
	
    return newImage;
}


@end