//
// File: SplashViewController.h
// Abstract: The view controller for documents of my teams.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController{
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
