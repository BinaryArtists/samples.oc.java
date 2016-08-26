//
// File: SplashViewController.m
// Abstract: The view controller for documents of my teams.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
// All Rights Reserved.

#import "SplashViewController.h"
#import "Constants.h"

@implementation SplashViewController

@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    self.title = @"WebDoc Mobile"; 

	return self;
}

- (void)viewDidUnload{
	activityIndicator = nil;
}

- (void)dealloc{
	[activityIndicator stopAnimating];
	[activityIndicator release];
	[super dealloc];	
}

- (void)viewDidLoad{
 
	[activityIndicator startAnimating];
}


@end
