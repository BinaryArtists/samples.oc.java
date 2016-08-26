//
// File: ModalViewController.h
// Abstract: The view controller presented modally with application info.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import <UIKit/UIKit.h>

@interface ModalViewController : UIViewController{
	UILabel *appName, *copyright;
}

@property (nonatomic, retain) IBOutlet UILabel *appName, *copyright;

- (IBAction)dismissAction:(id)sender;

@end
