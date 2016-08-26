//
//  ThreadAppDelegate.m
//  ThreadDemo
//
//  Created by Henry Yu on 10/27/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import "ThreadAppDelegate.h"

@implementation ThreadAppDelegate

@synthesize window;
@synthesize spinner;
@synthesize answerLabel;
@synthesize button;

- (void)updateText:(NSString *)answer{
    [spinner stopAnimating];
    //answerLabel.text = answer;
	UIFont *font = [[UIFont boldSystemFontOfSize:47] autorelease];
	[answerLabel performSelector:@selector(setFont:) withObject:font afterDelay:0.1f];
	[answerLabel performSelector:@selector(setText:) withObject:answer afterDelay:0.1f];
}

- (void) handleTextPost: (NSNotification *)notification{
	id nobj = [notification object];
	[self performSelectorOnMainThread:@selector(updateText:) withObject:nobj waitUntilDone:YES];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    answerLabel.text = @"?";
    [[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(handleTextPost:) 
												 name:@"PostText" object:nil];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (IBAction)beginDeepThought:(id)sender
{
    [spinner startAnimating];
    button.hidden = YES;
    
    [NSThread detachNewThreadSelector:@selector(backgroundThinking) toTarget:self withObject:nil];
}

- (void)backgroundThinking
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:5];
	NSString *request = @"Thousands!";	
    //[self performSelectorOnMainThread:@selector(didFindAnswer:) withObject:request waitUntilDone:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PostText" object:request];
    [pool release];
	
	
}


- (void)dealloc {
    [window release];
    [spinner release];
    [answerLabel release];
    [button release];
    
    [super dealloc];
}


@end
