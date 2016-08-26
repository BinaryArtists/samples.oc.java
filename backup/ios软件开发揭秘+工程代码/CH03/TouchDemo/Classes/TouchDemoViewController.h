//
//  TouchDemoViewController.h
//  TouchDemo
//
//  Created by Henry Yu on 6/4/09.
//  Copyright Sevenuc.com. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchableView.h"
@protocol TouchableViewDelegate;
@interface TouchDemoViewController : UIViewController <TouchableViewDelegate> {
	CGRect labelRect;

	UILabel *touchDownLabel;
	UILabel *touchDownRepeatLabel;
	UILabel *touchDragInsideLabel;
	UILabel *touchDragOutsideLabel;
	UILabel *touchDragEnterLabel;
	UILabel *touchDragExitLabel;
	UILabel *touchUpInsideLabel;
	UILabel *touchUpOutsideLabel;
	UILabel *touchCancelLabel;
	
	UIButton *button;
	
}


@end

