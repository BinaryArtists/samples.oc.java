//
//  PopoverSlider.h
//  PopoverSlider
//
//  Created by Henry Yu on 10/27/10.
//  Copyright Sevenuc.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderValueViewController.h"

@interface PopoverSlider : UISlider {

	UIPopoverController *popoverController;
	SliderValueViewController *sliderValueController;
}

@end
