//
//  UIDialView.h
//  RadioDial
//
//  Created by Henry, Yu on 3/11/10.
//  Copyright 2010  Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIDialViewDelegate
@optional
- (void)dialValue:(int)tag Value:(float)value;
@end

@interface UIDialView : UIView {
	id<UIDialViewDelegate> delegate;
	NSTimer *timer;
	UIImageView *iv;
	float maxValue,minValue;
	CGAffineTransform initialTransform ;
	float currentValue;
}
@property(nonatomic,assign)id<UIDialViewDelegate>delegate;
@property CGAffineTransform initialTransform;
@property float currentValue;

@end
