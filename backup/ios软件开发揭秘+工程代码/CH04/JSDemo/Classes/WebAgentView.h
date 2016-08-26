//
//  WebAgentView.h
//  JSDemo
//
//  Created by Henry Yu on 10-11-08.
//  Copyright 2010 Sevenuc.com All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebAgentView : UIWebView <UIWebViewDelegate>{
	NSMutableArray *arrayLanguages;	
}

- (void)createWebViewContent;
- (NSString*)createLanguagePage;	
- (void)executeJSFunction:(NSString *)js;

@end

