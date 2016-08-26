//
//  LongTextFieldViewController.h
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol LongTextFieldEditingViewControllerDelegate <NSObject>
@required
- (void)takeNewString:(NSString *)newValue;
- (UINavigationController *)navController;  //Return the navigation controller
@end

@interface LongTextFieldViewController : UITableViewController{
	BOOL		isHistory;
    NSString    *string;
    UITextView  *textView;    
    id<LongTextFieldEditingViewControllerDelegate>  delegate;
}

@property  BOOL		isHistory;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign)  id <LongTextFieldEditingViewControllerDelegate> delegate;

- (void)cancel;
- (void)save;

@end

