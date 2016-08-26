//
//  SplashViewController.h
//  Splash
//
//  Created by Henry Yu on 1/14/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface SplashViewController : UIViewController {
	NSTimer *timer;
	UIImageView *splashImageView;	
	MainViewController *viewController;
}

@property(nonatomic,retain) NSTimer *timer;
@property(nonatomic,retain) UIImageView *splashImageView;
@property(nonatomic,retain) MainViewController *viewController;

@end
