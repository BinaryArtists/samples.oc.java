//
//  UCDatePicker.h
//
//  Created by Henry Yu on 10-11-06.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UCDatePickerDelegate;

@interface UCDatePicker : UITextField<UITextFieldDelegate> {
@private
	UIActionSheet *action;	
	NSString *dateFormat;
	id<UCDatePickerDelegate> delegate;
}

@property(nonatomic,copy) NSString *dateFormat;
@property(nonatomic,assign) IBOutlet id<UCDatePickerDelegate> delegate;
- (void)initComponents;

@end

@protocol UCDatePickerDelegate
@required
- (void)dateChanged:(NSDate*)date;
- (void)buttonClicked:(NSInteger)button;

@end
