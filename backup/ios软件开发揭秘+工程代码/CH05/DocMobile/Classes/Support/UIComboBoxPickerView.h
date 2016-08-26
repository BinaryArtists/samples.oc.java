//
//  UIComboBoxPickerView.h
//
//  Created by Henry Yu on 09-06-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIComboBox;

@interface UIComboBoxPickerView : UIPickerView {
@private
	CGRect hiddenFrame;
	CGRect visibleFrame;
	UIToolbar *toolbar;
	UIComboBox* field;	
}

@property(nonatomic, assign) CGRect hiddenFrame;
@property(nonatomic, assign) CGRect visibleFrame;
@property(nonatomic, assign) UIComboBox* field;

- (void)toggle;
- (void)saveSelection:(id)sender;

@end
