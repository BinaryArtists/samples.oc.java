//
//  DefinitionViewController.m
//  Vocabulary
//
//  Created by Henry Yu on 10/21/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "DefinitionViewController.h"

@implementation DefinitionViewController

@synthesize word;

- (NSURLRequest *)urlRequest
{
	NSString *urlString = @"http://www.google.com/dictionary";
	if (self.word) urlString = [urlString stringByAppendingFormat:@"?langpair=en%%7Cen&q=%@", self.word];
	return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

- (void)setWord:(NSString *)newWord
{
	if (word != newWord) {
		[word release];
		word = [newWord copy];
	}
	self.title = word;
	if (webView.window) [webView loadRequest:[self urlRequest]];
}

- (void)loadView
{
	webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	webView.scalesPageToFit = YES;
	self.view = webView;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[webView loadRequest:[self urlRequest]];
}

- (void)dealloc
{
	[webView release];
	[word release];
    [super dealloc];
}

@end
