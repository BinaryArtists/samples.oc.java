//
//  SplashViewController.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashViewController : UIViewController 
                                  
{
	UIImageView* _imageView;
	NSString *indicatorId;
	NSData *imgData;
	UIToolbar *toolbar;
	int adjustToolbar;
		
}

@property int adjustToolbar;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;


- (void)createBottomBar;
-(void)resetAllViews;

//A. LINGERIE B. EYELASHES C. CATEGORIES D. ABOUTUS
-(IBAction)goLINGERIE:(id)sender;
-(IBAction)goEYELASHES:(id)sender;
-(IBAction)goCATEGORIES:(id)sender;
-(IBAction)goABOUTUS:(id)sender;
-(IBAction)goLanguage:(id)sender;
- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation;
- (void)setupPortraitMode;

@end




