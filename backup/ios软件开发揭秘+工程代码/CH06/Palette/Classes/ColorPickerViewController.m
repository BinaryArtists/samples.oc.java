//
//  ColorPickerViewController.m
//  Palette
//
//  Created by Henry Yu on 10-11-15.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "ColorPickerView.h"


@implementation ColorPickerViewController


NSString *keyForHue = @"hue";
NSString *keyForSat = @"sat";
NSString *keyForBright = @"bright";


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSUserDefaults *saveColors = [NSUserDefaults standardUserDefaults];
	ColorPickerView *theView = (ColorPickerView*) [self view];
	
	
	if ([saveColors floatForKey:keyForHue])
		[theView setCurrentHue:[saveColors floatForKey:keyForHue]];
	else
		[theView setCurrentHue:0.5];
	
	if ([saveColors floatForKey:keyForSat])
		[theView setCurrentHue:[saveColors floatForKey:keyForSat]];
	else
		[theView setCurrentSaturation:0.5];
	
	if ([saveColors floatForKey:keyForBright])
		[theView setCurrentHue:[saveColors floatForKey:keyForBright]];
	else
		[theView setCurrentBrightness:0.5];
		
}

- (void) viewWillDisappear :(BOOL)animated { 

	NSUserDefaults *saveColors = [NSUserDefaults standardUserDefaults];
	
	ColorPickerView *theView = (ColorPickerView*) [self view];
	
	[saveColors setFloat:[theView currentHue] forKey:keyForHue];
	[saveColors setFloat:[theView currentSaturation] forKey:keyForSat];
	[saveColors setFloat:[theView currentBrightness] forKey:keyForBright];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (UIColor *) getSelectedColor {
	return [(ColorPickerView *) [self view] getColorShown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];	
}

@end
