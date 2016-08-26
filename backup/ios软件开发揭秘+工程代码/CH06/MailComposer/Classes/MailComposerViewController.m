//
//  MailComposerViewController.m
//  MailComposer
//
//  Created by Henry Yu on 26/07/10.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "MailComposerViewController.h"

@implementation MailComposerViewController



- (void)viewDidLoad {
	if ([MFMailComposeViewController canSendMail])
		button.enabled = YES;
}


- (IBAction)buttonPressed {
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
	[mailController setSubject:@"Send Mail"];
	[mailController setMessageBody:@"This message is from iPad...." isHTML:NO];
	[self presentModalViewController:mailController animated:YES];
	[mailController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	[button release];
    [super dealloc];
}


@end
