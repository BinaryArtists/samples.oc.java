//
//  MoviePlayerViewController.m
//  MoviePlayer
//
//  Created by Henry Yu on 3/27/10.
//  Copyright Sevenuc. All rights reserved.
//

#import "MoviePlayerViewController.h"

@implementation MoviePlayerViewController
@synthesize player;
@synthesize viewForMovie;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 
 	 self.player = [[MPMoviePlayerController alloc] init];
	 self.player.contentURL = [self movieURL];	 
	 
	 // Set movie player layout
	 [self.player setFullscreen:YES];	
	 // May help to reduce latency
	 [self.player prepareToPlay];		
	 self.player.initialPlaybackTime = 5;
	 self.view.backgroundColor = [UIColor blackColor];
	
	 CGRect bounds = self.viewForMovie.bounds;
	 self.player.view.frame = bounds;
	 self.player.view.autoresizingMask = 
		UIViewAutoresizingFlexibleWidth |
		UIViewAutoresizingFlexibleHeight;
	 self.player.controlStyle = MPMovieControlStyleNone;

	 [self.viewForMovie addSubview:player.view];
	 [self.player play];
	 
	 PlayerControls *controls = [[PlayerControls alloc] initWithPlayer:self.player];
	 controls.view.alpha = 0.0;
	 CGRect rect = controls.view.frame;
	 rect.origin.y = (bounds.size.height - rect.size.height)/2; 
	 rect.origin.x = (bounds.size.width - rect.size.width)/2; 
	 controls.view.frame = rect;
	 [self.player.view  addSubview:controls.view];	 
	 	 
 }


 -(NSURL *)movieURL
 {
	 NSBundle *bundle = [NSBundle mainBundle];
	 NSString *moviePath = 
		[bundle 
		 pathForResource:@"Dangerous" 
		 ofType:@"mov"];
	 if (moviePath) {
		 return [NSURL fileURLWithPath:moviePath];
	 } else {
		return nil;
	 }
 }


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	//ImageViewWithTime *imageView = recognizer.view;
	//self.player.currentPlaybackTime = [imageView.time floatValue];
}


- (void)removeView:(NSTimer*)theTimer {
	UIView *view = [theTimer userInfo];
	[view removeFromSuperview];
}


@end
