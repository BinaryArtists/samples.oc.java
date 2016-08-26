//
//  SliderValueViewController.h
//  PopoverSlider
//
//  Created by Henry Yu on 10/27/10.
//  Copyright Sevenuc.com All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SliderValueViewController : UIViewController {

	IBOutlet UILabel *sliderValue;
}

@property (nonatomic, retain) IBOutlet UILabel *sliderValue;

-(void)updateSliderValueTo:(CGFloat)_value;

@end
