//
//  MailComposerViewController.h
//  MailComposer
//
//  Created by Henry Yu on 26/07/10.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MailComposerViewController : UIViewController 
<MFMailComposeViewControllerDelegate>
{
	IBOutlet UIButton *button;
}

- (IBAction)buttonPressed;


@end

