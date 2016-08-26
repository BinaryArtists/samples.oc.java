//
//  PictureViewController.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "PictureViewController.h"
#import "IPhotoGallery.h"
#import "BACIAppDelegate.h"
#import "AsyncNet.h"
#import "Constants.h"
#import "Reachability.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation PictureViewController

- (id)initWithVideoFile:(NSString*)_filename
{
    if (self = [super init])
    {
		activityIndicator = nil;
		isInitFromPortraitMode = TRUE;
        videoFile = _filename;		
    }
    return self;
}

-(void)backToBigPicture:(id)sender{
				
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
	[appNavgitor setNavigationBarHidden:YES animated:NO];
	
#if RORATION_LEFT	
	appDelegate.adjustToolBar = TRUE;
	appDelegate.adjustToolBar2 = TRUE;
	[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
	
#endif	
		
	[self.parentViewController dismissModalViewControllerAnimated:NO];
		
}

- (void)asyncPhotoRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo
{
	[activityIndicator stopAnimating];
	self.view.backgroundColor = [UIColor blackColor];
	if(data == nil) return;
		
	int i, count = [[self.view subviews] count];
	for( i = 0; i< count; i++){
		UIView *view = [[self.view subviews] objectAtIndex:i];
		if(view.tag == 1000){
			[view removeFromSuperview];
			break;
		}
	}	
	
	int screenWidth = 1024;    	
    UIImage *image = [UIImage imageWithData:data];
		
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake((screenWidth-image.size.width)/2, 44, image.size.width, image.size.height);	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	imageView.transform = CGAffineTransformMakeRotation(-1.57);//M_PI/2.0);
	CGContextRestoreGState(context);
	imageView.frame = CGRectMake(22, 0,1024-22,768);
	
	[self.view addSubview:imageView];
	[self.view sendSubviewToBack:imageView];	
    	
}

- (void)asyncPhotoRequestFailed:(NSError *)error
					   userInfo:(NSDictionary *)userInfo
{
    
    [activityIndicator stopAnimating];
    
}

-(void)getFullScreenImage{	
	[[AsyncNet instance]
	 addRequestForUrl:videoFile
	 successTarget:self
	 successAction:@selector(asyncPhotoRequestSucceeded:userInfo:)
	 failureTarget:self
	 failureAction:@selector(asyncPhotoRequestFailed:userInfo:)
	 userInfo:nil];
			
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
	
	//NetworkStatus connectionStatus = [reachability internetConnectionStatus];
	NetworkStatus connectionStatus = [reachability remoteHostStatus];
	if( connectionStatus == NotReachable ){
		return FALSE;
	}else{
		return TRUE;
	}
}

- (void)showReachabilityView:(BOOL)isConnectable{
	//BOOL isConnectable = [self isReachabilitable];	
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

- (void)viewDidLoad {
	[super viewDidLoad];
			
	UIBarButtonItem *backButton =[[UIBarButtonItem alloc]
				 initWithImage:[UIImage imageNamed:@"arrowLeft.png"]
				 style:UIBarButtonItemStylePlain
									target:self action:@selector(backToBigPicture:)];
		
	int screenWidth =  768; //bounds.size.width;	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth,44)];
		
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
	toolbar.frame = CGRectMake(0, 0,44,768-20);
	
    [self.view addSubview:toolbar];
	[self.view bringSubviewToFront:toolbar];	
	
#if NETWORK_SUPPORT 
	BOOL isConnectable = [self isReachabilitable];	
	[self showReachabilityView:isConnectable];
	
	if(isConnectable ){
		timer = [NSTimer scheduledTimerWithTimeInterval: 6.0
												  target: self
												selector: @selector(handleTimer:)
												userInfo: nil
												 repeats: NO];
		//start animating...
		if(activityIndicator == nil){
			activityIndicator = [[UIActivityIndicatorView alloc] 
								 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);				
			//CGFloat screenHeight = [[NSScreen mainScreen] frame].size.height;
			activityIndicator.center = CGPointMake(1024/2, 768/2);  

			[self.view addSubview: activityIndicator];
			[activityIndicator startAnimating];	
		}
		[self getFullScreenImage];
	}
	
#endif	
	
}

- (UIImage*)rotate:(UIImage*)src direction:(UIImageOrientation)orientation
{
    UIGraphicsBeginImageContext(src.size);	
  	CGContextRef context = UIGraphicsGetCurrentContext();

    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }	
    [src drawAtPoint:CGPointMake(0, 0)];
	
    return UIGraphicsGetImageFromCurrentImageContext();
}


-(void)viewWillAppear:(BOOL)animated
{ 
	[super viewWillAppear:animated];	
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait 
		||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
	}			
	
	BACIAppDelegate* appDelegate = 
	   (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
	[appNavgitor setToolbarHidden:YES animated:YES];
	[appNavgitor setNavigationBarHidden:YES animated:NO];
		

#if NETWORK_SUPPORT 
	//start animating...
	
#else
	int screenWidth =  768; 
	NSString* tempFile = [videoFile substringFromIndex:7];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isExists = [fileManager fileExistsAtPath:tempFile];
	if(!isExists){
		NSLog(@"ERROR,file %@ is not exists!",tempFile);
		return;
	}
	NSString *escapedPath = [videoFile stringByReplacingOccurrencesOfString:@" " 
																 withString:@"%20"];
	NSURL *url = [NSURL URLWithString: escapedPath];
	UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
				
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake((screenWidth-image.size.width)/2, 44, image.size.width, image.size.height);	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	imageView.transform = CGAffineTransformMakeRotation(-1.57);//M_PI/2.0);
	CGContextRestoreGState(context);
	imageView.frame = CGRectMake(22, 0,1024-22,768);
	
	[self.view addSubview:imageView];
	[self.view sendSubviewToBack:imageView];
#endif	
	
}

// Code from: http://discussions.apple.com/thread.jspa?messageID=7949889
//variation of Squeegy's answer here. Resolves landscape right for my screenshot
- (UIImage *)scaleAndRotateImage:(UIImage *)image {
	int kMaxResolution = 1024; // Or whatever
		
	CGImageRef imgRef = image.CGImage;	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);	
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = roundf(bounds.size.width / ratio);
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = roundf(bounds.size.height * ratio);
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	
	boundHeight = bounds.size.height;
	bounds.size.height = bounds.size.width;
	bounds.size.width = boundHeight;
	transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width/2.0);
	transform = CGAffineTransformRotate(transform, -1.57); //M_PI/2.0);
	
	UIGraphicsBeginImageContext(bounds.size);	
	CGContextRef context = UIGraphicsGetCurrentContext();	
	UIImageOrientation orient = image.imageOrientation;
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
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
        //Do Your Landscape Changes here
		//[self setupPortraitMode];
		CGRect mainframe = CGRectMake(0, 0, 1024, 768);
		self.view.frame = mainframe;
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
                //Do Your Portrait Changes here
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
