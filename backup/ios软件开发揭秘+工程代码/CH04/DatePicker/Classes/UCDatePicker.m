//
//  UCDatePicker.m
//
//  Created by Henry Yu on 10-11-06.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import "UCDatePicker.h"

@implementation UCDatePicker

@synthesize delegate,dateFormat;

- (BOOL)canBecomeFirstResponder {
	return YES;	
}

- (BOOL)becomeFirstResponder {
	if(action == nil)
		[self initComponents]; 	
	if(action != nil){
		UIWindow* appWindow = [self window];
		[action showInView: appWindow];
		[action setBounds:CGRectMake(0, 0, 320, 500)];
	}	
    return YES;
}

- (void)dealloc {
	delegate = nil;
	if(action != nil){
	    [action dismissWithClickedButtonIndex:1  animated:YES];	
	    [action release];
	    action = nil;
	}
	[super dealloc];
}

- (void)didMoveToSuperview 
{	
	action = nil;
	dateFormat = @"yyyy-MM-dd HH:mm:ss";
	// lets load our indecicator image and get its size.
	CGRect bounds = self.bounds;
	UIImage* image = [UIImage imageNamed:@"downArrow.png"];
	CGSize imageSize = image.size;
	
	// create our indicator imageview and add it as a subview of our textview.
	CGRect imageViewRect = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width, 
									  (bounds.size.height/2) - (imageSize.height/2), 
									  imageSize.width, imageSize.height);

	UIImageView *indicator = [[UIImageView alloc] initWithFrame:imageViewRect];
	indicator.image = image;
	[self addSubview:indicator];
	[indicator release];   
	
}

-(void) didMoveToWindow {
	UIWindow* appWindow = [self window];  
	if (appWindow != nil) {        
        [self initComponents];        	
    }
}

- (void)doCancelClick:(id)sender{
	[action dismissWithClickedButtonIndex:0  animated:YES];	
	[delegate buttonClicked:0];		
}

- (void)doDoneClick:(id)sender{
	[action dismissWithClickedButtonIndex:1  animated:YES];	
	[delegate buttonClicked:1];		
}

- (void)initComponents{	
	if(action != nil) return;
	//Create UIDatePicker with UIToolbar.
	action = [[UIActionSheet alloc] initWithTitle:@""
										 delegate:nil
								cancelButtonTitle:nil
						   destructiveButtonTitle:nil
								otherButtonTitles:nil];
	
	UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
	datePicker.datePickerMode = UIDatePickerModeDate;
	datePicker.maximumDate = [NSDate date];	
	[datePicker addTarget:self action:@selector(dateChanged:) 
	 forControlEvents:UIControlEventValueChanged];

	
	UIToolbar *datePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	datePickerToolbar.barStyle = UIBarStyleBlackOpaque;
	[datePickerToolbar sizeToFit];
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];	
	UIBarButtonItem *btnFlexibleSpace = [[UIBarButtonItem alloc] 
										 initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
										 target:self action:nil];
	[barItems addObject:btnFlexibleSpace];
	[btnFlexibleSpace release];
	
	UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
								  target:self
								  action:@selector(doCancelClick:)];
	[barItems addObject:btnCancel];
	[btnCancel release];
	
	UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] 
								initWithBarButtonSystemItem:UIBarButtonSystemItemDone
								target:self
								action:@selector(doDoneClick:)];
	
	[barItems addObject:btnDone];
	[btnDone release];
	[datePickerToolbar setItems:barItems animated:YES];
	[barItems release];
	
	NSDate *now = [[NSDate alloc] init];
	[datePicker setDate:now animated:NO];
	[now release];
	
	[action addSubview: datePickerToolbar];
	[action addSubview: datePicker];
	
	[datePicker release];
	[datePickerToolbar release];
	
}

- (void)dateChanged:(id)sender{	
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:dateFormat];	
	NSDate *date = ((UIDatePicker*)sender).date;
	NSString *dateString = [format stringFromDate:date];
    [self setText:dateString];	
	[delegate dateChanged:date];	
}

@end
