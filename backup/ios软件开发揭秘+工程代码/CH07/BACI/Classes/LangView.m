//
//  LangView.m
//  BACI
//
//  Created by Henry Yu on 10-06-09.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "LangView.h"
#import <objc/runtime.h>	//necessary for tweaking the UIWebView
#import "BACIAppDelegate.h"

@implementation LangView

-(id)initWithFrame:(CGRect)frame{	
	if(self=[super initWithFrame:frame]){
	
		self.backgroundColor=[UIColor clearColor];
		//init the arrayPages
		arrayLanguages =[[NSMutableArray alloc]initWithCapacity:5];		
				
		//initialization for this UIWebView delegate (javascript function)
		self.delegate=self;		
			
	}
	return self;
}

-(void)produceHTMLForPage{

	NSMutableString* string =[[NSMutableString alloc]initWithCapacity:10];	
	//init a mutable string, initial capacity is not a problem, it is flexible
 	[string appendString:
	@"<html>"
		"<head>"
	     "<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 320\"/>"
	      "<script>"
	      "function imageClicked(i){"
	      "var clicked=true;"
	      "window.location=\"/click/\"+i;"
	      "}"
	      "</script>"
	 "</head>"
		"<body style=\"background-color: transparent;margin-top:0px;margin-left:0px\">"
	    "<center>"
	 ];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L1')\">English</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L2')\">Deutsch</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L3')\">Français</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L4')\">Español</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L5')\">Italiano</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L6')\">Pусский</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L7')\">日本語</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L8')\">中文</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L9')\">العربية</a><br>"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L10')\">বাংলা</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L11')\">ελληνικά</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L12')\">हिन्दी</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L13')\">한국어</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L14')\">Bahasa Indonesia</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L15')\">Nederlands</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L16')\">Norsk</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L17')\">اردو</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L18')\">Polski</a><br>"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L19')\">Português</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L20')\">Svenska</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L21')\">தமிழ்</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L22')\">Česky</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L23')\">Türkçe</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L24')\">Tiếng Việt</a>"];
	[string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
	[string appendString:@"<a href=\"javascript:void(0)\" style=\"color:grey;text-decoration: none; font-family:'Helvetica Neue'; font-size:16px;\" onMouseDown=\"imageClicked('L25')\">עברית</a>"];
	

	[string appendString:@"</center></body>"
	 "</html>"
	 ];		
	//creating the HTMLString
	
	self.opaque = NO;
	self.backgroundColor= [UIColor clearColor];
	[self loadHTMLString:string baseURL:nil];	
	//load the HTML String on UIWebView
	
	[string release];		
    
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {	//linking the javascript to call the iPhone control
	
	NSString *url = request.mainDocumentURL.relativePath;
	if(url != nil) {			
			
			NSArray *strings = [url componentsSeparatedByString: @"/"];
			NSString *language  = [strings objectAtIndex:[strings count]-1];			
		    
		    BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
		    appDelegate.currentLanguage = language;
		    [appDelegate showMainmenuView];
			return false;
	
     }	
	
	if ( [request.mainDocumentURL.relativePath isEqualToString:@"/click/true"] ) {	
		//the image is clicked, variable click is true
				
		UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"JavaScript called" 
					 message:@"You've called iPhone provided control from javascript!!" 
					 delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return false;
	}
	
	return true;	
	
}

-(void)drawRect:(CGRect)rect{
	//method that's called to draw the view
	[self produceHTMLForPage];
} 

-(void)dealloc{			
	[arrayLanguages release];
	[super dealloc];
}


@end
