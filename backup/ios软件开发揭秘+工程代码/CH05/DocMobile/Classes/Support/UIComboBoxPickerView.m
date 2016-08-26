//
//  UIComboBoxPickerView.m
//
//  Created by Henry Yu on 09-06-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import "UIComboBoxPickerView.h"
#import "UIComboBox.h"

@interface UIComboBox(PickerViewExtension)
// call in our picker field to now if control was hidden or not. Used
// to toggle indicator in the field.
-(void) pickerViewHidden:(BOOL)wasHidden;

@end

@implementation UIComboBoxPickerView

@synthesize hiddenFrame;
@synthesize visibleFrame;
@synthesize field;

-(void) dealloc {
    field = nil;
	if(toolbar != nil)
		[toolbar release];
    [super dealloc];
}

-(BOOL)resignFirstResponder {
	// when we resign the first responder we want to hide our selves.
    if (!self.hidden)
		[self toggle];
	
    // do what ever the control needs to do normally.
	return [super resignFirstResponder];
}

-(BOOL) canBecomeFirstResponder {
	// we need to allow this control to become the first responder
    // this allows us to hide what ever keyboards are up and allows us
    // to get a resign when we lose focus.
    return YES;
}

-(void) sendNotification:(NSString*) notificationName {
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:
			[NSValue valueWithCGRect:self.bounds] forKey:UIPickerViewBoundsUserInfoKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:notificationName 
										object:self.field userInfo:userInfo];
}

-(void)didMoveToWindow{
    if(toolbar == nil)
	{
        toolbar = [[UIToolbar alloc] init];
		toolbar.hidden = YES;
		toolbar.barStyle = UIBarStyleBlackTranslucent;
		[toolbar sizeToFit];
		UIWindow* appWindow = [self window];
		CGRect windowBounds = [self bounds];
		
        // caluclate the toolbar position.		
		toolbar.frame = CGRectMake(0, 480-windowBounds.size.height-45, 320, 45);
		
		NSMutableArray *barItems = [[NSMutableArray alloc] init];
		UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] 
									  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
									  target:self action:nil];
		[barItems addObject:flexSpace];
				
		/*UIBarButtonItemStyleBordered */
		UIBarButtonItem *btn = [[UIBarButtonItem alloc] 
								initWithTitle:@"Done" style:UIBarButtonItemStyleDone								
								target:self action:@selector(saveSelection:)];
		[barItems addObject:btn];
		
		[toolbar setItems:barItems animated:YES];		
		[appWindow addSubview:toolbar];		
    }    
}


-(void)saveSelection:(id)sender{
	//NSLog(@"saveSelection");
	toolbar.hidden = YES;
	self.hidden = YES;
}

-(void) toggle {
	if (self.hidden) {
		self.hidden = NO;
		toolbar.hidden = NO;
		
        // this will toggle the indicator.
        [field pickerViewHidden:NO];
        
        // send the notification that we are about to show.
		[self sendNotification:UIPickerViewWillShownNotification];
		
        // set up our animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.25];
		[self setFrame:visibleFrame];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(slideInAnimationDidStop:finished:context:)];
		[UIView commitAnimations];
		
        // become the first responder.
		[self becomeFirstResponder];
		
	}
	else {
		toolbar.hidden = YES;	
         // this will toggle the indicator.
        [field pickerViewHidden:YES];
        
        // send our notification that we are about to hide.
		[self sendNotification:UIPickerViewWillHideNotification];
		
        // setup our animation
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:.25];
		[self setFrame:hiddenFrame];	
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(slideOutAnimationDidStop:finished:context:)];
		[UIView commitAnimations];

	}
	
}

- (void)slideOutAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.hidden = YES;
	toolbar.hidden = YES;
    [self sendNotification:UIPickerViewDidHideNotification];
}

- (void)slideInAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self sendNotification:UIPickerViewDidShowNotification];
}


@end
