//
//  LanguageViewController.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LangView.h"

@interface LanguageViewController : UIViewController {
	BOOL bChanged;
	UIImageView *view1; //background
	LangView *view2;    //language box
	id timer; 
	int iAnimation;
	int adjustToolbar;
	CGRect langViewFrame;
	NSMutableArray *animationArray;
	UIToolbar *toolbar;
	UIToolbar *toolbar2;
	UIBarButtonItem* langBarButtonItem;
}

@property int adjustToolbar;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (void)initAnimationViews;
- (void)changeView:(id)sender;
- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation;
- (void)setupPortraitMode;
- (void)createLanguageBar;

@end
