//
//  MainViewController.h
//  MultiLineText
//
//  Created by Henry Yu on 3/29/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiLineTextViewController.h"

@interface MainViewController : UIViewController
 <MultiLineTextViewControllerDelegate,UITextFieldDelegate>{
     NSString  *comment;
	 UITextView *commentField;
}

@property(nonatomic, retain) IBOutlet UITextView *commentField;

- (IBAction)editComment:(id)sender;

@end

