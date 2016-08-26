//
//  MyTextField.m
//  WebDoc
//
//  Created by Henry Yu on 09-06-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "MyTextField.h"


@implementation MyTextField
@synthesize delegate;


-(void) didMoveToSuperview 
{
	[self addTarget:self
				  action:@selector(textFieldDone:)
		forControlEvents:UIControlEventEditingDidEndOnExit];
		
	// lets load our indecicator image and get its size.
	CGRect bounds = self.bounds;
	UIImage* image = [UIImage imageNamed:@"downArrow.png"];
	CGSize imageSize = image.size;
		
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width, (bounds.size.height/2) - (imageSize.height/2), imageSize.width, imageSize.height);
	button.frame = frame;	// match the button's size with the image size
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	// set the button's target to the event handler
	[button addTarget:self action:@selector(comboxButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];	
	[self addSubview:button];
	
}

- (void)textFieldDone:(id)sender
{
//	[sender resignFirstResponder];	
}

- (BOOL)canBecomeFirstResponder{
	return FALSE;	
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
//	[theTextField resignFirstResponder];
	return YES;	
}

- (void)keyboardWillShow:(NSNotification*)notification
{
//    [self resignFirstResponder];
//	return [delegate keyboardReturnEvent:self.tag];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	//EditingMode = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	//EditingMode = NO;
}

- (void)comboxButtonTapped:(id)sender event:(id)event
{
	return [delegate comboxButtonTapped:self event:event];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length >= 10){
        textView.text = [textView.text substringToIndex:10];
    }
}


@end
