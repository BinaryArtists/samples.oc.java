//
//  MailComposerAppDelegate.h
//  MailComposer
//
//  Created by Henry Yu on 26/07/10.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MailComposerViewController;

@interface MailComposerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MailComposerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MailComposerViewController *viewController;

@end

