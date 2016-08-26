//
//  DefinitionViewController.h
//  Vocabulary
//
//  Created by Henry Yu on 10/21/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefinitionViewController : UIViewController
{
	UIWebView *webView;
	NSString *word;
}

@property (copy) NSString *word;

@end
