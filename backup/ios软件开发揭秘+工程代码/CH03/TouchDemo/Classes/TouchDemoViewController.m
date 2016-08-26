//
//  TouchDemoViewController.m
//  TouchDemo
//
//  Created by Henry Yu on 6/4/09.
//  Copyright Sevenuc.com. 2009. All rights reserved.
//

#import "TouchDemoViewController.h"
#import "TouchableView.h"

#define DEFAULT_ALPHA 0.3

@implementation TouchDemoViewController


- (UILabel *)addLabelWithText:(NSString *)text {
	UILabel *label = [[UILabel alloc] initWithFrame:labelRect];

	label.font = [UIFont boldSystemFontOfSize:20.0];
	label.textColor = [UIColor blueColor];
	label.textAlignment = UITextAlignmentCenter;
	label.alpha = DEFAULT_ALPHA;
	label.text = text;
	[self.view addSubview:label];
	[label release];

	labelRect.origin.y += labelRect.size.height + 10.0;

	return label;
}

- (void)highlightLabel:(UILabel *)label {
	label.alpha = 1.0;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.5];
	label.alpha = DEFAULT_ALPHA;
	[UIView commitAnimations];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIImage *image = [UIImage imageNamed:@"apple.jpg"];		
	CGRect imageRect = CGRectMake(0.0, 0.0, 100, 0.0);
	imageRect.size.height = 100 * image.size.height / image.size.width;
	TouchableView *touchImageView = [[TouchableView alloc] initWithFrame:imageRect];
	touchImageView.backgroundColor = [UIColor clearColor];
	touchImageView.tag = 100;
	touchImageView.image = image;
	touchImageView.center = CGPointMake(imageRect.size.width/2, 100);
	touchImageView.delegate = self;
	[self.view addSubview:touchImageView];
	[touchImageView release];	

	labelRect = CGRectMake(0.0, 20.0, 320.0, 24.0);

	touchDownLabel = [self addLabelWithText:@"Touch Down"];
	touchDownRepeatLabel = [self addLabelWithText:@"Touch Down Repeat"];
	touchDragInsideLabel = [self addLabelWithText:@"Drag Inside"];
	touchDragOutsideLabel = [self addLabelWithText:@"Drag Outside"];
	touchDragEnterLabel = [self addLabelWithText:@"Drag Enter"];
	touchDragExitLabel = [self addLabelWithText:@"Drag Exit"];
	touchUpInsideLabel = [self addLabelWithText:@"Touch Up Inside"];
	touchUpOutsideLabel = [self addLabelWithText:@"Touch Up Outside"];
	touchCancelLabel = [self addLabelWithText:@"Touch Cancelled"];
	
	CGRect buttonRect = CGRectMake(100.0, 365.0, 120.0, 50.0);
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = buttonRect;
	[button setTitle:@"Touch Me" forState:UIControlStateNormal];;
	[self.view addSubview:button];
	

    [button addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
	[button addTarget:self action:@selector(touchDownRepeat) forControlEvents:UIControlEventTouchDownRepeat];
	[button addTarget:self action:@selector(touchDragInside) forControlEvents:UIControlEventTouchDragInside];
	[button addTarget:self action:@selector(touchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
	[button addTarget:self action:@selector(touchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
	[button addTarget:self action:@selector(touchDragExit) forControlEvents:UIControlEventTouchDragExit];
	[button addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
	[button addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchCancel];

}

- (void)touchDown { [self highlightLabel:touchDownLabel]; }
- (void)touchDownRepeat { [self highlightLabel:touchDownRepeatLabel]; }
- (void)touchDragInside { [self highlightLabel:touchDragInsideLabel]; }
- (void)touchDragOutside { [self highlightLabel:touchDragOutsideLabel]; }
- (void)touchDragEnter { [self highlightLabel:touchDragEnterLabel]; }
- (void)touchDragExit { [self highlightLabel:touchDragExitLabel]; }
- (void)touchUpInside { [self highlightLabel:touchUpInsideLabel]; }
- (void)touchUpOutside { [self highlightLabel:touchUpOutsideLabel]; }
- (void)touchCancel { [self highlightLabel:touchCancelLabel]; }

#pragma mark -
#pragma mark TouchableView Delegate Functions

- (void)touchDragBegin{ [self highlightLabel:touchDownLabel]; }
- (void)touchDragEnd{ [self highlightLabel:touchDragOutsideLabel]; }
- (void)touchDragMove{ [self highlightLabel:touchDownRepeatLabel]; }
- (void)touchDragCancel{ [self highlightLabel:touchCancelLabel]; }

- (void)dealloc {
	[touchDownLabel release];
	[touchDownRepeatLabel release];
	[touchDragInsideLabel release];
	[touchDragOutsideLabel release];
	[touchDragEnterLabel release];
	[touchDragExitLabel release];
	[touchUpInsideLabel release];
	[touchUpOutsideLabel release];
	[touchCancelLabel release];
	[button release];
	
	[super dealloc];
}

@end
