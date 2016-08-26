//
//  WebAgentView.m
//  JSDemo
//
//  Created by Henry Yu on 10-11-08.
//  Copyright 2010 Sevenuc.com All rights reserved.
//

#import "WebAgentView.h"
#import <objc/runtime.h> 
#import "AppDelegate.h"

@implementation WebAgentView

-(id)initWithFrame:(CGRect)frame{	
	if(self = [super initWithFrame:frame]){
		self.opaque = NO;
		self.delegate = self;
		self.backgroundColor=[UIColor clearColor];
		arrayLanguages =[[NSMutableArray alloc]initWithCapacity:25];			
						
	}
	return self;
}

- (void)createWebViewContent{
	
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"png"];
	NSString *templatePath = [[NSBundle mainBundle] pathForResource:@"welcome" ofType:@"html"];
	NSString *template = [[[NSString alloc] initWithContentsOfFile:templatePath usedEncoding:NULL error:NULL] autorelease];
	template = [template stringByReplacingOccurrencesOfString:@"[[[TOPIMG]]]" withString:[NSString stringWithFormat:@"file://%@",imagePath]];
	NSString *langContent = [self createLanguagePage];
	template = [template stringByReplacingOccurrencesOfString:@"[[[LANGUAGELIST]]]" withString:langContent];
	[langContent release];
	
	//Load the HTML String on UIWebView
	[self loadHTMLString:template baseURL:nil];				
	//Adjust position
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	self.frame = CGRectMake(0, 20,screenWidth, screenHeight);
	
}

- (NSString*)createLanguagePage{
	
	arrayLanguages = [[NSMutableArray alloc] initWithObjects:
		@"English",@"Deutsch",@"Français",@"Español",@"Italiano",@"Pусский",@"日本語",@"中文",
		@"العربية",@"বাংলা",@"ελληνικά",@"हिन्दी",@"한국어",@"Bahasa Indonesia",@"Nederlands",@"Norsk",
		@"اردو",@"Polski",@"Português",@"Svenska",@"தமிழ்",@"Česky",@"Türkçe",@"Tiếng Việt",@"עברית>",nil];
	
	NSMutableString* string =[[NSMutableString alloc]initWithCapacity:1024];	
	//init a mutable string, initial capacity is not a problem, it is flexible
			
	for(int i = 0; i < [arrayLanguages count]; i++){
		[string appendString:@"<a href=\"javascript:void(0)\" "];
		[string appendString:@"style=\"color:grey;text-decoration: none; "];
		[string appendString:@"font-family:'Helvetica'; font-size:14px;\" "];		
		[string appendString:[NSString stringWithFormat:
							  @" onMouseDown=\"imageClicked('L%d')\">%@</a>",
							  i,[arrayLanguages objectAtIndex:i]]];
	    [string appendString:@"&nbsp;&nbsp;|&nbsp;&nbsp;"];
		if(i%3 == 0)
			[string appendString:@"<br>"];
	}
	
	return string;	    	
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:
   (NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	   //linking the javascript to call the iPhone control
	
	NSString *url = request.mainDocumentURL.relativePath;	
	if(url != nil) {
		NSLog(@"url:%@",url);		
		NSArray *strings = [url componentsSeparatedByString: @"/"];
		NSString *token  = [strings objectAtIndex:[strings count]-1];
		NSString *text = @"";		
		if([token hasPrefix:@"L"]){
			int i = [[token substringFromIndex:1] intValue];
			text = [NSString stringWithFormat:@"language:%@ be selected",
			                      [arrayLanguages objectAtIndex:i]]; 
		}else{			
			//NSString *jsCommand = 
			//  [NSString stringWithFormat:@"changeTapHighlightColor(%d);", token]; 
			//[self executeJSFunction:jsCommand];
			text = [NSString stringWithFormat:@"Area:%@ be selected",token];
		}			
		UIAlertView* alert=
		[[UIAlertView alloc]initWithTitle:@"javascript message" 
								  message:text 
								 delegate:self 
						cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return FALSE;		
	}		
		
	return TRUE;
	
}

- (void)drawRect:(CGRect)rect{
	//method that's called to draw the view
	[self createWebViewContent];	
} 

//- (void)webViewDidStartLoad:(UIWebView  *)webView{	
//}

//- (void)webViewDidFinishLoad:(UIWebView  *)webView{		
//}


- (void)executeJSFunction:(NSString *)jsCommand{
	NSString *result = [self stringByEvaluatingJavaScriptFromString:jsCommand];		
	NSLog(@"result:%@",result);
}

- (void)dealloc{			
	[arrayLanguages release];
	[super dealloc];
}


@end
