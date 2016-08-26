//
//  LangView.h
//  BACI
//
//  Created by Henry Yu on 10-06-09.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface LangView : UIWebView <UIWebViewDelegate>{
		NSMutableArray *arrayLanguages;	
}

-(void)produceHTMLForPage;	

@end
