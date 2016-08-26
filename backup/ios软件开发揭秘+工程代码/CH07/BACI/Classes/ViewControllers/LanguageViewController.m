//
//  LanguageViewController.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "LanguageViewController.h"
#import "BACIAppDelegate.h"
#import "Constants.h"

@implementation LanguageViewController

@synthesize imageView = view1;
@synthesize adjustToolbar;

- (void) handleTimer: (id) atimer
{
	 
	if(iAnimation > [animationArray count]-1){
	    [atimer invalidate];
	    atimer = nil;
		
		for(int i = 0; i < [animationArray count]-1;i++){
			UIImageView *tempView = [animationArray objectAtIndex:i];
			[tempView removeFromSuperview];
			[tempView release];
		}				
		
		[self createLanguageBar];
		
		
		#if WITH_SEVENUC
			int screenWidth =  1024; 
			int screenHeight =  768; 			
			UIImage *image3 = [UIImage imageNamed:@"splash6.png"];
		    UIImageView *view3 = [[UIImageView alloc] initWithImage:image3];
			
			CGRect optionsFrame = view3.frame;
			optionsFrame.origin.x = (screenWidth-optionsFrame.size.width)/2;
			optionsFrame.origin.y = (screenHeight-optionsFrame.size.height)/2;
			view3.frame = optionsFrame;
			[self.view addSubview:view3];
			[self.view bringSubviewToFront:view3];		 
        #endif
		return;
	}
	
	UIImageView *tempView = [animationArray objectAtIndex:iAnimation];
	iAnimation++;
	tempView.hidden = NO;
	[self.view bringSubviewToFront:tempView];
	
	
}

- (LanguageViewController*)initWithFrame:(CGRect)frame{
	adjustToolbar = 0;
	langViewFrame = frame;	
	return [self init];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
/*
- (void)loadView
{
	[super loadView];
	UIView *view = [[UIView alloc] initWithFrame: langViewFrame];
	self.view = view;
	[view release];
}*/

- (void)createLanguageBar{
	
	int screenWidth = 1024;
	if(adjustToolbar == 0){
		adjustToolbar = 1;
	   toolbar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 768-64, screenWidth, 44)];
	}else{
	   toolbar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 768-44, screenWidth, 44)];
	}
	
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *langText = [appDelegate getLocalTextString:@"LANGUAGE"];
	
	CGRect buttonFrame = CGRectMake( 0, 0, 180, 30 );
	UIButton *langLabel = [[UIButton alloc] initWithFrame: buttonFrame];
	[langLabel setTitle: langText forState: UIControlStateNormal];
	langLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
	langLabel.titleLabel.textAlignment = UITextAlignmentCenter;
	[langLabel setShowsTouchWhenHighlighted:YES];
	[langLabel setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
	langLabel.titleLabel.font = [UIFont fontWithName:@"Arial" size: 16.0];
	[langLabel addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *langButton = [[UIBarButtonItem alloc] initWithCustomView:langLabel];
				
		
	UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:
								  UIBarButtonSystemItemFlexibleSpace
								  target:nil action:nil];
	UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:
								   UIBarButtonSystemItemFlexibleSpace
								   target:nil action:nil];
		
	NSArray *newItems = [NSArray arrayWithObjects:leftSpace,langButton,rightSpace,nil];
	[toolbar2 setItems:newItems];
	[langLabel release];
	[langButton release];	
	toolbar2.translucent = NO;
    toolbar2.barStyle = UIBarStyleBlack;
	[toolbar2 sizeToFit];	
    [self.view addSubview:toolbar2];
	[self.view bringSubviewToFront:toolbar2];
	
	
}

- (void)loadView
{
	[super loadView];
	[self initAnimationViews];
	
}

- (void)initAnimationViews{
	//CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  1024; //bounds.size.width;
	int screenHeight =  768; //bounds.size.height;
		
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"01.jpg" ofType:nil]];
	view1.image = image;
	CGRect mainframe = CGRectMake(0, -20, screenWidth, screenHeight);
	view1.frame = mainframe;
	
	iAnimation = 0;
	animationArray = [[NSMutableArray alloc] initWithCapacity:5];
	int i = 0;
	for(i = 0; i < 5;i++){
		int idx = i+1;
		NSString *file = [NSString stringWithFormat:@"%02d.jpg",idx];
		UIImage *tmpImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:nil]];
		UIImageView *tempView = [[UIImageView alloc] initWithImage:tmpImage];
		tempView.hidden = YES;
		tempView.frame = mainframe;
		[self.view addSubview:tempView];
		[animationArray addObject:tempView];
	}
	
	
	CGRect boxframe = CGRectMake(0, 0, 1024, 768-64);
	view2 = [[LangView alloc] initWithFrame:boxframe];
	
	// Position the options at bottom of screen
	CGRect boxFrame = view2.frame;
	boxFrame.origin.x = 0;
	boxFrame.origin.y = screenHeight+boxFrame.size.height+200;
	view2.frame = boxFrame;
	
	
	[self.view addSubview:view1];
	[self.view addSubview:view2];
    [self.view bringSubviewToFront:view1];
		
	
#if HAVE_ANIMATION	
	timer = [NSTimer scheduledTimerWithTimeInterval: 1
											 target: self
										   selector: @selector(handleTimer:)
										   userInfo: nil
											repeats: YES];
#endif
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

	BACIAppDelegate* appDelegate = 
	   (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
	[appNavgitor setToolbarHidden:YES animated:YES];
	[appNavgitor setNavigationBarHidden:YES animated:YES];
		
#if !HAVE_ANIMATION	
	if(adjustToolbar == 0){
       [self createLanguageBar];
	}else{
		
	}
#endif	
	bChanged = FALSE;	
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;	
	screenWidth =  1024;
	screenHeight =  768;
	
	//check interface orientation at first view and adjust it
	//if it is in portrait mode
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
		 self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		//[self setupPortraitMode];
	}else{
		//screenWidth =  bounds.size.width;
		//screenHeight =  bounds.size.height;
	}
	
	if(adjustToolbar){
	    CGRect mainframe = CGRectMake(0, 22, 1024, 768);
	    self.view.frame = mainframe;	   
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
   	[super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
			
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

//IBAction
-(void)changeView:(id)sender{
	
	if(bChanged)
		return;
	bChanged = TRUE;
		
	// For the animation, move the view up by its own height.
	CGRect optionsFrame = view2.frame;
    [UIView beginAnimations:nil context:nil];
	
	optionsFrame.origin.y = 768-(64+44);
	view2.hidden = NO;
    view2.frame = optionsFrame;
	view2.opaque = NO;
	view2.backgroundColor = [UIColor clearColor];
	
	[UIView commitAnimations];	
	[self.view bringSubviewToFront:view2];
		
	[toolbar2 removeFromSuperview];
	
}

#pragma mark -
#pragma mark Orientation

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  	[self.view setFrame:CGRectMake(0, 0, 1024, 768)];
	
}

/**
 * Sent to the view controller just before
 * the user interface begins rotating. This is
 * the place to control the display of master
 * and detail view.
 */
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval) duration
{
	//only handle the interface orientation of portrait mode
	if(interfaceOrientation == UIInterfaceOrientationPortrait ||
	   interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		[self setupPortraitMode];
	}else {
		//re-adjust detail view					
		//call super method
		[super willAnimateRotationToInterfaceOrientation:interfaceOrientation
												duration:duration];			
		
	}	
		
		
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
		[self setupPortraitMode];
    }
    else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        //Do Your Portrait Changes here
    }
}

// Thanks to http://intensedebate.com/profiles/fgrios for this code snippet
- (void)setupPortraitMode
{
	//adjust master view	
	CGRect mainframe = CGRectMake(0, 0, 768, 1024-44);
	self.view.frame = mainframe;	
	
}


@end
