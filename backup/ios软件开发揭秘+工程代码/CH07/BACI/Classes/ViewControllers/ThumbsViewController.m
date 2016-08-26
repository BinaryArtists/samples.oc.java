//
//  ThumbsViewController.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "ThumbsViewController.h"
#import "ThumbsViewControllerDelegate.h"
#import "ThumbsView.h"
#import "BACIAppDelegate.h"
#import "SlideshowViewController.h"
#import "Constants.h"
#import "IPhotoGallery.h"

@implementation ThumbsViewController

@synthesize outerFrame;
@synthesize innerFrame;
@synthesize imageView = _imageView;

- (void)setDelegate:(id<ThumbsViewControllerDelegate>)_delegate
{
	delegate = [_delegate retain];	
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    	
	return self;
}

- (ThumbsViewController*)initWithFrame:(CGRect)frame{
	thumbsViewFrame = frame;	
	return [self init];
}


- (id)initWithDelegate:(id<ThumbsViewControllerDelegate>)_delegate
{
    if (self = [super init])
	
	{
        delegate = [_delegate retain];
		
		CGRect bounds = [[UIScreen mainScreen] bounds];
		int screenWidth =  bounds.size.width;
		int screenHeight =  bounds.size.height;
				
		UIImage *imgBg = [UIImage imageNamed:@"Default.png"];
		UIColor *colorBg = [[UIColor alloc] initWithPatternImage:imgBg];
		[self.view setBackgroundColor:colorBg];
		[colorBg release];
		        				
		outerFrame = CGRectMake(0, 44, screenWidth, screenHeight-44);
        innerFrame = CGRectMake(0, 20 + 44, screenWidth, screenHeight-20-44);
        
        self.wantsFullScreenLayout = YES;
    }
    return self;
}

- (void)loadView
{
	[super loadView];
		
	//CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  1024; //bounds.size.width;
	int screenHeight =  768; //bounds.size.height;
		
	outerFrame = CGRectMake(0, 0, screenWidth, screenHeight);
	innerFrame = CGRectMake(0, 0, screenWidth, screenHeight);
	
	self.wantsFullScreenLayout = YES;
	
	
    thumbsView = [[ThumbsView alloc] initWithFrame:outerFrame controller:self];
	CGRect mainframe = CGRectMake(0, 44, screenWidth, screenHeight);
	thumbsView.autoresizesSubviews = YES;
	thumbsView.frame = mainframe;
	
	self.view.autoresizesSubviews = YES;	
	[self.imageView addSubview:thumbsView];
    [self reloadData];
		
}


- (void)viewDidLoad
{	
	[self createSearchBar];
	
}

- (void)viewDidUnload
{
    [thumbsView release];
    thumbsView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait 
		||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
	}
	
	CGRect mainframe = CGRectMake(0, 0, 1024, 768);
	self.view.frame = mainframe;
    
	BACIAppDelegate* appDelegate = 
	   (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
	[appNavgitor setToolbarHidden:YES animated:YES];
	
	[self createBottomBar];
		
    isVisible = YES;
    if (dataReloadPending)
        [self reloadData];
	
	if(appDelegate.adjustToolBar2){
		appDelegate.adjustToolBar2 = FALSE;
		
		CGRect mainframe = CGRectMake(0, -20, 1024, 768+22);
		self.view.frame = mainframe;
		
	}
	
	if(toolbar != nil){
		UIButton *langLabel = (UIButton *)[[toolbar.items objectAtIndex:1] customView];				
		NSString *langLINGERIE = [appDelegate getLocalTextString:@"LINGERIE"];
		[langLabel setTitle: langLINGERIE forState: UIControlStateNormal];
		UIButton *langLabel2 = (UIButton *)[[toolbar.items objectAtIndex:2] customView];
		NSString *langEYELASHES = [appDelegate getLocalTextString:@"EYELASHES"];
		[langLabel2 setTitle: langEYELASHES forState: UIControlStateNormal];
		UIButton *langLabel3 = (UIButton *)[[toolbar.items objectAtIndex:3] customView];
		NSString *langCATEGORIES = [appDelegate getLocalTextString:@"CATEGORIES"];
		[langLabel3 setTitle: langCATEGORIES forState: UIControlStateNormal];		
		UIButton *langLabel5 = (UIButton *)[[toolbar.items objectAtIndex:5] customView];
		NSString *langLANGUAGE = [appDelegate getLocalTextString:@"LANGUAGE"];
		[langLabel5 setTitle: langLANGUAGE forState: UIControlStateNormal];		
	}
	
	if(toolbar2 != nil){
		UIButton *langLabel = (UIButton *)[[toolbar2.items objectAtIndex:4] customView];
		NSString *langSearch = [appDelegate getLocalTextString:@"Search"];		
		[langLabel setTitle: langSearch forState: UIControlStateNormal];				
	}
	
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    isVisible = NO;
}

- (void)dealloc
{
    [thumbsView release];
	[toolbar release];
	[toolbar2 release];
    [delegate release];
    [super dealloc];
}

- (void)reloadData
{
    if (isVisible == NO)
    {
        dataReloadPending = YES;
        return;
    }
    dataReloadPending = NO;    
    int n = [delegate thumbsViewControllerPhotosCount:self];
	int total = n;//*2;
    [thumbsView setNumberOfPhotos:total];
	
	BACIAppDelegate* appDelegate = 
	    (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	int startId = [appDelegate getCurrentSeriesStartId:0];
    for (int i = 0; i < n; ++i){
		int idx = startId+i; //+1;
		NSString *location = [NSString stringWithFormat:@"Thumbs/65x89/%03d_F.jpg",idx];
        [delegate thumbsViewController:self fetchPhotoAtIndex:i Location:location];
		
	}
}

- (void)fetchedPhoto:(UIImage *)photo atIndex:(int)index
{
    [thumbsView setPhoto:photo atIndex:index];
}

- (void)thumbTapped:(int)index
{
    [delegate thumbsViewController:self selectedPhotoAtIndex:index];
}


- (void)createSearchBar{
	
	int screenWidth = 1024;
	toolbar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
	
	UIBarButtonItem *backButton =[[UIBarButtonItem alloc]
								  initWithImage:[UIImage imageNamed:@"arrowLeft.png"]								  
								  style:UIBarButtonItemStylePlain 
								  target:self action:@selector(leftBarButtonAction:)];
	
	UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:
								  UIBarButtonSystemItemFlexibleSpace
								  target:nil action:nil];
	UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:
								   UIBarButtonSystemItemFlexibleSpace
								   target:nil action:nil];
		
		
	UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 44.0f)];
	searchBar.placeholder = @"keyword match text";
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
	
	
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *langSearch = [appDelegate getLocalTextString:@"search"];
	
	CGRect buttonFrame = CGRectMake( 0, 768-64, 120, 30 );
	UIButton *langLabel = [[UIButton alloc] initWithFrame: buttonFrame];
	[langLabel setTitle: langSearch forState: UIControlStateNormal];
	[langLabel setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
	langLabel.titleLabel.font = [UIFont fontWithName:@"Arial" size: 16.0];
	[langLabel setShowsTouchWhenHighlighted:YES];
	langLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
	[langLabel addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithCustomView:langLabel];
			
	NSArray *newItems = [NSArray arrayWithObjects:backButton,leftSpace,rightSpace,searchItem,searchButton,nil];
	[toolbar2 setItems:newItems];
	[searchButton release];	
	toolbar2.translucent = NO;
    toolbar2.barStyle = UIBarStyleBlack;
	
    [self.view addSubview:toolbar2];
	
}

- (void)createBottomBar{
	int fontSize = 16;
	int screenWidth = 1024;
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 768-44, screenWidth, 44)];
	
	BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSString *langLINGERIE = [appDelegate getLocalTextString:@"LINGERIE"];
	
	CGRect buttonFrame = CGRectMake( 0, 0, [appDelegate textWidthByFontSize:langLINGERIE FontSize:fontSize], 30 );
	UIButton *langLabel = [[UIButton alloc] initWithFrame: buttonFrame];
	[langLabel setTitle: langLINGERIE forState: UIControlStateNormal];
	[langLabel setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];	

	[langLabel setTitleColor: RGB(96, 189, 242) forState:UIControlStateSelected];
	langLabel.titleLabel.adjustsFontSizeToFitWidth = YES;
	[langLabel setShowsTouchWhenHighlighted:YES];
	langLabel.titleLabel.font = [UIFont fontWithName:@"Arial" size: fontSize];
	[langLabel addTarget:self action:@selector(goLINGERIE:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:langLabel];
	if(appDelegate.mainMenu == LINGERIE){
		[langLabel setSelected:YES];
	}
	
	NSString *langEYELASHES = [appDelegate getLocalTextString:@"EYELASHES"];
	buttonFrame = CGRectMake( 0, 0, [appDelegate textWidthByFontSize:langEYELASHES FontSize:fontSize], 30 );
	UIButton *langLabel2 = [[UIButton alloc] initWithFrame: buttonFrame];
	[langLabel2 setTitle: langEYELASHES forState: UIControlStateNormal];
	[langLabel2 setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
	
	[langLabel2 setTitleColor: RGB(96, 189, 242) forState:UIControlStateSelected];
	langLabel2.titleLabel.adjustsFontSizeToFitWidth = YES;
	[langLabel2 setShowsTouchWhenHighlighted:YES];
	langLabel2.titleLabel.font = [UIFont fontWithName:@"Arial" size: fontSize];
	[langLabel2 addTarget:self action:@selector(goEYELASHES:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:langLabel2];
	if(appDelegate.mainMenu == EYELASHES){
		[langLabel2 setSelected:YES];
	}
	
	NSString *langCATEGORIES = [appDelegate getLocalTextString:@"CATEGORIES"];
	buttonFrame = CGRectMake( 0, 0, [appDelegate textWidthByFontSize:langCATEGORIES FontSize:fontSize], 30 );
	UIButton *langLabel3 = [[UIButton alloc] initWithFrame: buttonFrame];
	[langLabel3 setTitle: langCATEGORIES forState: UIControlStateNormal];
	[langLabel3 setShowsTouchWhenHighlighted:YES];
	langLabel3.titleLabel.adjustsFontSizeToFitWidth = YES;
	[langLabel3 setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
	
	[langLabel3 setTitleColor: RGB(96, 189, 242) forState:UIControlStateSelected];
	langLabel3.titleLabel.font = [UIFont fontWithName:@"Arial" size: fontSize];
	[langLabel3 addTarget:self action:@selector(goCATEGORIES:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *buttonItem3 = [[UIBarButtonItem alloc] initWithCustomView:langLabel3];
	if(appDelegate.mainMenu == CATEGORIES){
		[langLabel3 setSelected:YES];
	}
	
	NSString *langLANGUAGE = [appDelegate getLocalTextString:@"LANGUAGE"];
	buttonFrame = CGRectMake( 0, 0, [appDelegate textWidthByFontSize:langLANGUAGE FontSize:fontSize], 30 );
	UIButton *langLabel5 = [[UIButton alloc] initWithFrame: buttonFrame];
	[langLabel5 setTitle: langLANGUAGE forState: UIControlStateNormal];
	[langLabel5 setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
	
	[langLabel5 setTitleColor: RGB(96, 189, 242) forState:UIControlStateSelected];
	[langLabel5 setShowsTouchWhenHighlighted:YES];
	langLabel5.titleLabel.adjustsFontSizeToFitWidth = YES;
	langLabel5.titleLabel.font = [UIFont fontWithName:@"Arial" size: fontSize];
	[langLabel5 addTarget:self action:@selector(goLanguage:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *buttonItem5 = [[UIBarButtonItem alloc] initWithCustomView:langLabel5];
	
	UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:
								  UIBarButtonSystemItemFlexibleSpace
								  target:nil action:nil];
	UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:
								   UIBarButtonSystemItemFlexibleSpace
								   target:nil action:nil];
	
	NSArray *newItems = [NSArray arrayWithObjects:leftSpace,
						 buttonItem1,buttonItem2,buttonItem3,buttonItem5,rightSpace,nil];
	[toolbar setItems:newItems];
	[langLabel release];
	[langLabel2 release];
	[langLabel3 release];

	[buttonItem1 release];	
	[buttonItem2 release];	
	[buttonItem3 release];

	toolbar.translucent = NO;
    toolbar.barStyle = UIBarStyleBlack;
    [self.view addSubview:toolbar];
	[self.view bringSubviewToFront:toolbar];	
	
}

#pragma mark -
#pragma mark Public

-(IBAction)leftBarButtonAction:(id)sender{
		
	BACIAppDelegate* appDelegate = 
	   (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
		
	int i, count = [appNavgitor.viewControllers count];
	for( i = 0; i< count; i++){
		UIViewController* controller = [appNavgitor.viewControllers objectAtIndex:i];
		
		if(controller.view.tag == kTagSeriesDetailView||
		   controller.view.tag == kTagBigpictureView||
		   controller.view.tag == kTagThumbView){
			
			[controller viewWillDisappear:NO];
			[controller.view removeFromSuperview];
			[controller viewDidDisappear:NO];
		}
	}
	[appDelegate showSeriesDetailView:0 fromType:kTagThumbView];
	
}

-(IBAction)doSearch:(id)sender{
	
	UISearchBar* searchBar = (UISearchBar *)[[toolbar2.items objectAtIndex:3] customView];
	NSString *text = searchBar.text;
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate doSearch:text];
}

-(void)resetAllViews{
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
	int i, count = [appNavgitor.viewControllers count];
	for( i = 0; i< count; i++){
		UIViewController* controller = [appNavgitor.viewControllers objectAtIndex:i];
		
		if(controller.view.tag == kTagSeriesView ||
		   controller.view.tag == kTagSeriesDetailView||
		   controller.view.tag == kTagBigpictureView||
		   controller.view.tag == kTagThumbView){
			
			[controller viewWillDisappear:NO];
			[controller.view removeFromSuperview];
			[controller viewDidDisappear:NO];
		}
	}
}



-(IBAction)goLINGERIE:(id)sender{
		
	UIButton *langLabel = (UIButton *)[[toolbar.items objectAtIndex:1] customView];
	[langLabel setSelected:YES];
	
	
	BACIAppDelegate* appDelegate =
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[self resetAllViews];
	[appDelegate showSeriesView:LINGERIE];
		
	
}

-(IBAction)goEYELASHES:(id)sender{
	
	UIButton *langLabel = (UIButton *)[[toolbar.items objectAtIndex:2] customView];
	[langLabel setSelected:YES];

	
	BACIAppDelegate* appDelegate =
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[self resetAllViews];
	[appDelegate showSeriesView:EYELASHES];
			
}

-(IBAction)goCATEGORIES:(id)sender{
	
	UIButton *langLabel = (UIButton *)[[toolbar.items objectAtIndex:3] customView];
	[langLabel setSelected:YES];
	
	
	BACIAppDelegate* appDelegate =
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[self resetAllViews];
	[appDelegate showSeriesView:CATEGORIES];
	
}

-(IBAction)goABOUTUS:(id)sender{
	
}

-(IBAction)goLanguage:(id)sender{
	
	UIButton *langLabel = (UIButton *)[[toolbar.items objectAtIndex:5] customView];
	[langLabel setSelected:YES];
	
	BOOL popViews = FALSE;
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
		
	popViews = TRUE;
	if(popViews){
				
		IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
		int i, count = [appNavgitor.viewControllers count];
		for( i = 0; i< count; i++){
			UIViewController* controller = [appNavgitor.viewControllers objectAtIndex:i];
		    			
			if(controller.view.tag == kTagSeriesView ||
			   controller.view.tag == kTagSeriesDetailView||
			   controller.view.tag == kTagBigpictureView||
			   controller.view.tag == kTagThumbView||
			   controller.view.tag == kTagMainmenuView||
			   controller.view.tag == kTagLanguageView){
				
			    [controller viewWillDisappear:NO];
			    [controller.view removeFromSuperview];
			    [controller viewDidDisappear:NO];
			}
		}
		
		[appDelegate showLanguageView];
	}
}

#pragma mark -
#pragma mark Orientation

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
