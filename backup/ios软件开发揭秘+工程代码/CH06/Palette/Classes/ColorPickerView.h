//
//  ColorPickerView.h
//  Palette
//
//  Created by Henry Yu on 10-11-15.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class GradientView;
@interface ColorPickerView : UIView {
	GradientView *gradientView;
	UIImage *backgroundImage; //Image that will sit in back on the view
	UIImage *closeButtonImage; //Image for close button
	UIImage *nextButtonImage; //Image for next button
	IBOutlet UIImageView *backgroundImageView;
	IBOutlet UIView *showColor;
	IBOutlet UIImageView *crossHairs;
	IBOutlet UIImageView *brightnessBar;
	
	IBOutlet UILabel *colorInHex;
	IBOutlet UILabel *Hcoords;
	IBOutlet UILabel *Scoords;
	IBOutlet UILabel *Lcoords;
	IBOutlet UILabel *Rcoords;
	IBOutlet UILabel *Gcoords;
	IBOutlet UILabel *Bcoords;
	
	
	
	//Private vars
	CGRect colorMatrixFrame;
	
	CGFloat currentBrightness;
	CGFloat currentHue;
	CGFloat currentSaturation;
	
	UIColor *currentColor;
	
	
	
}

@property (nonatomic,retain) UIImage *backgroundImage;
@property (nonatomic,retain) UIImage *closeButtonImage;
@property (nonatomic,retain) UIImage *nextButtonImage;

@property (readwrite) CGFloat currentBrightness;
@property (readwrite) CGFloat currentHue;
@property (readwrite) CGFloat currentSaturation;

- (UIColor *) getColorShown;

@end
