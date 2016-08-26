//
//  MyTextField.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyTextFieldDelegate
@required
- (void)keyboardReturnEvent:(NSInteger)notification;
- (void)comboxButtonTapped:(id)sender event:(id)event;
@end

@interface MyTextField : UITextField<UITextFieldDelegate> {
@private
	UIImageView* indicator;		
	id<MyTextFieldDelegate> delegate;
}

@property(nonatomic,assign) IBOutlet id<MyTextFieldDelegate> delegate;
- (void)comboxButtonTapped:(id)sender event:(id)event;


@end

