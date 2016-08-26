//
//  ThreadAppDelegate.h
//  ThreadDemo
//
//  Created by Henry Yu on 10/27/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    
    UIActivityIndicatorView *spinner;
    UILabel *answerLabel;
    UIButton *button;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *answerLabel;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)beginDeepThought:(id)sender;

@end

