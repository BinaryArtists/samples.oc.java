//
//  VideoPlay_iPadViewController.m
//  VideoPlay_iPad
//
//  Created by Henry Yu on 14/07/10.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "IPhotoGallery.h"
#import "BACIAppDelegate.h"
#import "AsyncNet.h"
#import "Reachability.h"
#import "Constants.h"

@implementation VideoPlayViewController

- (id)initWithVideoFile:(NSString*)_filename
{
    if (self = [super init])
    {
		videoPlayer = nil;
		activityIndicator = nil;
        videoFile = _filename;		
    }
    return self;
}

-(void)backToPlayList:(id)sender{
		
	if(videoPlayer != nil){
	    [videoPlayer stop];		
		[[NSNotificationCenter defaultCenter] removeObserver: self];		
	    videoPlayer = nil;
	}
		
	[self.parentViewController dismissModalViewControllerAnimated:NO];				
	
}

- (void)fetchMovieFile{
	 
	 [[AsyncNet instance]
	 addRequestForUrl:videoFile
	 successTarget:self
	 successAction:@selector(asyncPhotoRequestSucceeded:userInfo:)
	 failureTarget:self
	 failureAction:@selector(asyncPhotoRequestFailed:userInfo:)
	 userInfo:nil];
}

- (void)asyncPhotoRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo{
	
	
}

- (void)asyncPhotoRequestFailed:(NSError *)error
					   userInfo:(NSDictionary *)userInfo{
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
#if VIDEOPLAY_WITH_MYTOOLBAR	
	
	int screenWidth =  1024; //bounds.size.width;
	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
		
	UIBarButtonItem *searchButton =[[UIBarButtonItem alloc]
				 initWithImage:[UIImage imageNamed:@"arrowLeft.png"]
				 style:UIBarButtonItemStylePlain
									target:self action:@selector(backToPlayList:)];
	
	UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:
								  UIBarButtonSystemItemFlexibleSpace
								  target:nil action:nil];
	UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:
								   UIBarButtonSystemItemFlexibleSpace
								   target:nil action:nil];
	
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc]
								   initWithTitle:NSLocalizedString(@"baci", @"")
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:nil];
	
	
	NSArray *newItems = [NSArray arrayWithObjects:searchButton,leftSpace,titleButton,rightSpace,nil];
	[toolbar setItems:newItems];
	[searchButton release];	
	toolbar.translucent = NO;
    toolbar.barStyle = UIBarStyleBlack;
	
    [self.view addSubview:toolbar];
	[self.view bringSubviewToFront:toolbar];
	
#endif	
		
#if !NETWORK_SUPPORT
	
	NSString* tempFile = [videoFile substringFromIndex:7];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isExists = [fileManager fileExistsAtPath:tempFile];
	if(!isExists){
		NSLog(@"ERROR,file %@ is not exists!",tempFile);
		return;
	}
		
	
#endif
	
	[self playMovie];
	
}

- (void)moviePlayerPlaybackStateChanged:(NSNotification *)notif
{
	NSLog(@"PlaybackState: %d", videoPlayer.playbackState);
		
}

- (void)moviePlayerLoadStateChanged:(NSNotification *)notif
{

	if (videoPlayer.loadState & MPMovieLoadStateStalled) {
		[activityIndicator startAnimating];
		[videoPlayer pause];
	} else if (videoPlayer.loadState & MPMovieLoadStatePlaythroughOK) {
		
		int i, count = [[self.view subviews] count];
		for( i = 0; i< count; i++){
			UIView *view = [[self.view subviews] objectAtIndex:i];
			if(view.tag == 1000){
				[view removeFromSuperview];
				break;
			}
		}	
		
		if(activityIndicator != nil){
			[activityIndicator stopAnimating];
			[activityIndicator removeFromSuperview];
			[activityIndicator release];
			activityIndicator = nil;	
		}
		[videoPlayer play];		
	}
	
}

// When the movie is done, release the controller.
-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
		
	[activityIndicator stopAnimating];
	
	MPMoviePlayerController* theMovie = [aNotification object];
	if(theMovie != nil){
		[theMovie stop];
			
		[[NSNotificationCenter defaultCenter]
		 removeObserver: self
		 name: MPMoviePlayerLoadStateDidChangeNotification
		 object: theMovie];
		
		[[NSNotificationCenter defaultCenter]
		 removeObserver: self
		 name: MPMoviePlayerPlaybackDidFinishNotification
		 object: theMovie];
		
		// Release the movie instance created in playMovieAtURL:
		[theMovie release];
	}
	
	videoPlayer = nil;
	
	[self backToPlayList:nil];
	
}

- (void) handleTimer: (id) atimer
{
	int i, count = [[self.view subviews] count];
	for( i = 0; i< count; i++){
		UIView *view = [[self.view subviews] objectAtIndex:i];
		if(view.tag == 1000){
			[view removeFromSuperview];
			break;
		}
	}	  
	[atimer invalidate];
	atimer = nil;
	
}

- (BOOL)isReachabilitable{
	// Check if the network is available, if not, show the hint and return.
	Reachability *reachability = [Reachability sharedReachability];
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	reachability.address = [appDelegate getBaseUrlIPAddress];
	
	NetworkStatus connectionStatus = [reachability remoteHostStatus];
	if( connectionStatus == NotReachable ){
		return FALSE;
	}else{
		return TRUE;
	}
}

- (void)showReachabilityView:(BOOL)isConnectable{
		
	UIImage *photo = [UIImage imageNamed:@"messagebox.png"];
	UIImageView *tempView = [[UIImageView alloc] initWithImage:photo];
	tempView.tag = 1000;
	//660x179
	NSString *ourText = @"";
	if( isConnectable ){
		ourText = @"You are now connecting through 3G mobile network, it may impose cost when downloading from internet";	
	}else{	
		ourText = @"You have not connected to network,please connect to network before viewing";
	}	
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	CGFloat width = [appDelegate textWidthByFontSize:ourText FontSize:28];
	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 660-10,176-8)];
	myLabel.text = ourText;	
	UIFont *font = [UIFont fontWithName:@"Arial" size:28];
	int i;
	for(i = 28; i > 10; i=i-2)
	{
		font = [font fontWithSize:i];
		CGSize constraintSize = CGSizeMake(654.0f, 176);
		CGSize labelSize = [myLabel.text sizeWithFont:font 
									constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
		if(labelSize.height <= 180.0f)
			break;
	}	
	myLabel.font = font;		
	myLabel.numberOfLines = 0;
	myLabel.lineBreakMode = UILineBreakModeWordWrap;
	myLabel.textAlignment = UITextAlignmentLeft;		
	myLabel.adjustsFontSizeToFitWidth = YES;						
	
	tempView.frame = CGRectMake((1024-width)/2, (768-176)/2, photo.size.width, photo.size.height);
	[tempView addSubview:myLabel];
	tempView.center = CGPointMake(1024/2, 768/2); 
	[self.view addSubview:tempView];			
	[self.view bringSubviewToFront:tempView];	
	
}

- (void)createToolbar{
		
	UIBarButtonItem *backButton =[[UIBarButtonItem alloc]
								  initWithImage:[UIImage imageNamed:@"arrowLeft.png"]
								  style:UIBarButtonItemStylePlain
								  target:self action:@selector(backToPlayList:)];
		
	int screenWidth =  768; //bounds.size.width;	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth,44)];
	toolbar.tag = 2000;
	UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:
								  UIBarButtonSystemItemFlexibleSpace
								  target:nil action:nil];
	UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:
								   UIBarButtonSystemItemFlexibleSpace
								   target:nil action:nil];
	
	UIBarButtonItem *titleButton = [[UIBarButtonItem alloc]
									initWithTitle:NSLocalizedString(@"baci", @"")
									style:UIBarButtonItemStylePlain
									target:self
									action:nil];
	
	NSArray *newItems = [NSArray arrayWithObjects:backButton,leftSpace,titleButton,rightSpace,nil];
	[toolbar setItems:newItems];
	[backButton release];	
	
    toolbar.barStyle = UIBarStyleBlack;	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	toolbar.transform = CGAffineTransformMakeRotation(-1.57);//M_PI/2.0);	
	CGContextRestoreGState(context);
	toolbar.frame = CGRectMake(0, 0,44,768);
	toolbar.center = CGPointMake(22, 768/2);
    [self.view addSubview:toolbar];
	[self.view bringSubviewToFront:toolbar];	
	
	
}

- (void)playMovie{
	
#if NETWORK_SUPPORT 
	NSString *escapedPath = videoFile;
	
	
	BOOL isConnectable = [self isReachabilitable];	
	[self showReachabilityView:isConnectable];
	
	if(isConnectable ){
		int i, count = [[self.view subviews] count];
		for( i = 0; i< count; i++){
			UIView *view = [[self.view subviews] objectAtIndex:i];
			if(view.tag == 2000){
				[view removeFromSuperview];
				break;
			}
		}
		timer = [NSTimer scheduledTimerWithTimeInterval: 5.0
												 target: self
											   selector: @selector(handleTimer:)
											   userInfo: nil
												repeats: NO];
		
	}else{
		[self createToolbar];
		return;
	}
	
#else
	NSString *escapedPath = [videoFile stringByReplacingOccurrencesOfString:@" " 
																  withString:@"%20"];
#endif
		
	NSURL *url = [NSURL URLWithString:escapedPath];
	videoPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
	
	// Set movie player layout
	[videoPlayer setControlStyle:MPMovieControlStyleFullscreen];
	[videoPlayer setFullscreen:YES];	
	// May help to reduce latency
	[videoPlayer prepareToPlay];		
	videoPlayer.initialPlaybackTime = 5;
	self.view.backgroundColor = [UIColor blackColor];
	videoPlayer.view.frame = CGRectMake(0, 0, 1024, 768);	
	[self.view addSubview:videoPlayer.view];
	[self.view sendSubviewToBack:videoPlayer.view];
		
	// Register for the playback finished notification
	[[NSNotificationCenter defaultCenter]
	 addObserver: self
	 selector: @selector(myMovieFinishedCallback:)
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: videoPlayer];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver: self
	 selector: @selector(moviePlayerLoadStateChanged:)
	 name: MPMoviePlayerLoadStateDidChangeNotification
	 object: videoPlayer];
	
	[[NSNotificationCenter defaultCenter]
	 addObserver: self
	 selector: @selector(moviePlayerPlaybackStateChanged:)
	 name: MPMoviePlayerPlaybackStateDidChangeNotification
	 object: videoPlayer];	
		
	// Movie playback is asynchronous, so this method returns immediately.
	
#if NETWORK_SUPPORT 
	
	//start animating...
	if(activityIndicator == nil){
		activityIndicator = [[UIActivityIndicatorView alloc] 
				 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);		
		activityIndicator.center = videoPlayer.view.center;
		[self.view addSubview: activityIndicator];
		[activityIndicator startAnimating];	
	}	
	
#endif	
	
}

-(void)viewWillAppear:(BOOL)animated
{ 
	[super viewWillAppear:animated];
	
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait 
		||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		//[self setupPortraitMode];
	}
	
	CGRect mainframe = CGRectMake(0, 0, 1024, 768);
	self.view.frame = mainframe;
	
	BACIAppDelegate* appDelegate = 
	   (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
	[appNavgitor setToolbarHidden:YES animated:YES];
	[appNavgitor setNavigationBarHidden:YES animated:NO];	

	
}


- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
		
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad {
//    [super viewDidLoad];
//}


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
	if(activityIndicator != nil){
		//[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator = nil;	
	}
    [super dealloc];
}

#pragma mark -
#pragma mark Orientation
//=========
- (void) willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
														duration:(NSTimeInterval)duration
{
	
	UIInterfaceOrientation toInterfaceOrientation = self.interfaceOrientation;
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait){
		
	}
	else {
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval) duration
{
		
} 


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   
	[self adjustViewsForOrientation:toInterfaceOrientation];    
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
		CGRect mainframe = CGRectMake(0, 0, 1024, 768);
		self.view.frame = mainframe;
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        
		CGRect mainframe = CGRectMake(0, 0, 768, 1024);
		self.view.frame = mainframe;	
    }
}

// Thanks to http://intensedebate.com/profiles/fgrios for this code snippet
- (void)setupPortraitMode
{
	//adjust master view
	CGRect mainframe = CGRectMake(0, 0, 1024, 768);
	self.view.frame = mainframe;	
	
}

@end
