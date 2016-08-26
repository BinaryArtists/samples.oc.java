//
//  UIComboBox.h
//
//  Created by Henry Yu on 09-06-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import <Foundation/Foundation.h>

extern NSString* UIPickerViewBoundsUserInfoKey;

extern NSString* UIPickerViewWillShownNotification;
extern NSString* UIPickerViewDidShowNotification;
extern NSString* UIPickerViewWillHideNotification;
extern NSString* UIPickerViewDidHideNotification;

@class UIComboBoxPickerView;
@protocol UIComboBoxDelegate;


@interface UIComboBox : UITextField<UITextFieldDelegate,
                                       UIPickerViewDataSource, 
                                       UIPickerViewDelegate> {
@private
	UIComboBoxPickerView* pickerView;
	NSMutableArray* componentStrings;
	NSString* formatString;
	UIImageView* indicator;		
	id<UIComboBoxDelegate> delegate;
}

@property(nonatomic,assign) IBOutlet id<UIComboBoxDelegate> delegate;
@property(nonatomic, copy) NSString* formatString;
- (void)refreshPickerView;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)pickerViewHiddenIt:(BOOL)wasHidden; 


@end

@protocol UIComboBoxDelegate
@required
- (void)selectedRowChange:(UIComboBox*)pickerField Row:(NSInteger)row inComponent:(NSInteger)component;
- (NSInteger)numberOfComponentsInPickerField:(UIComboBox*)pickerField;
- (NSInteger)pickerField:(UIComboBox*)pickerField numberOfRowsInComponent:(NSInteger)component;
- (NSString*)pickerField:(UIComboBox *)pickerField titleForRow:(NSInteger)row forComponent:(NSInteger)component;
@end
