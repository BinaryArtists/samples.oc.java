//
//  MultiLineTextViewController.h
//  MultiLineText
//
//  Created by Henry Yu on 3/29/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MultiLineTextViewControllerDelegate <NSObject>
@required
- (void)takeNewString:(NSString *)newValue;
- (UINavigationController *)navController;  //Return the navigation controller
@end

@interface MultiLineTextViewController : UITableViewController{

    NSString    *string;
    UITextView  *textView;    
    id<MultiLineTextViewControllerDelegate>  delegate;
}

@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, assign)  id <MultiLineTextViewControllerDelegate> delegate;

- (void)cancel;
- (void)save;

@end

