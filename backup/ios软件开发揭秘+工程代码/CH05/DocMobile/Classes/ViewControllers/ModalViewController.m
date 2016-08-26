//
// File: ModalViewController.m
// Abstract: The view controller presented modally with application info.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import "ModalViewController.h"
#import "Constants.h"

@interface ModalViewController ()
- (id)infoValueForKey:(NSString *)key;
@end

@implementation ModalViewController

@synthesize appName, copyright;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    self.title = NSLocalizedString(@"WebDoc Mobile", @"");
	
	return self;
}

- (void)dealloc{
    [appName release];
    [copyright release];
	[super dealloc];	
}

- (void)viewDidLoad{
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.appName.text = @"WebDoc Mobile"; 
	self.copyright.text = @"Copyright(c) 2010 AMBISIG"; 
}

- (void)viewDidUnload{
	self.appName = nil;
	self.copyright = nil;
}

- (id)infoValueForKey:(NSString *)key{
	return [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:key] ? : [[[NSBundle mainBundle] infoDictionary] objectForKey:key];
}

- (IBAction)dismissAction:(id)sender{
	[self.parentViewController dismissModalViewControllerAnimated:YES];	
}

@end
