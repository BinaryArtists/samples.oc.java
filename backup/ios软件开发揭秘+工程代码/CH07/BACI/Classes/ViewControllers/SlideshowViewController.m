//
//  SlideshowViewController.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "SlideshowViewController.h"
#import "SlideshowViewControllerDelegate.h"
#import "SlideshowView.h"
#import "PictureViewController.h"
#import "VideoPlayViewController.h"
#import "IPhotoGallery.h"
#import "BACIAppDelegate.h"
#import "Constants.h"
#import "PageViewController.h"
#import "DataSource.h"

#define INFOBBAR_VIEW     201
#define INFORBUTTON_VIEW  202
#define INDICATOR_VIEW    203
#define INDICATOR_VIEW2   204

@implementation JKCustomAlert

@synthesize backgroundImage, alertText;

- (id)initWithImage:(UIImage *)image text:(NSString *)text {
    if (self = [super init]) {
		alertTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		alertTextLabel.textColor = [UIColor whiteColor];
		alertTextLabel.backgroundColor = [UIColor clearColor];
		alertTextLabel.font = [UIFont boldSystemFontOfSize:28.0];
		int width = 120, height = 60;
		self.frame = CGRectMake((1024-width)/2, (768-height)/2, width, height);
		
		CGSize size  = CGSizeMake(height,width);
		UIGraphicsBeginImageContext( size );
		[image drawInRect:CGRectMake(0,0,size.width,size.height)];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();		
		self.backgroundImage = newImage;
		
		[self addSubview:alertTextLabel];        
		self.alertText = text;	
		
		
    }
    return self;
}


-(void)hideAlert:(id)sender {
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void) setAlertText:(NSString *)text {
	alertTextLabel.text = text;
}

- (NSString *) alertText {
	return alertTextLabel.text;
}

- (void)drawRect:(CGRect)rect {
    	
}

- (void) layoutSubviews {
	alertTextLabel.transform = CGAffineTransformIdentity;
	[alertTextLabel sizeToFit];
	
	CGRect textRect = alertTextLabel.frame;
	textRect.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(textRect)) / 2;
	textRect.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(textRect)) / 2;
	textRect.origin.y -= 30.0;
	
	alertTextLabel.frame = textRect;	
	alertTextLabel.transform = CGAffineTransformMakeRotation(- M_PI * .08);
	alertButton.transform = CGAffineTransformMakeRotation(- M_PI * .08);
}

- (void) show {
	[super show];
	
	CGSize imageSize = self.backgroundImage.size;
	self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
	
	[self performSelector:@selector(hideAlert:) withObject:nil afterDelay:1.0];
}

- (void)dealloc {
	[alertTextLabel release];
	
    [super dealloc];
}

@end

@implementation SlideshowViewController

@synthesize currentNumber,isFirst,isReachBorder;
@synthesize iOffSet,iPhotoNumber,fromBigType;
@synthesize sereisNameIndex,selectedPhotoIndex,lastPageNumber;

- (SlideshowViewController*)initWithFrame:(CGRect)frame{
	slidesViewFrame = frame;	
	return [self init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
        return nil;
    
    self.title = @"B.A.C.I"; 
	
	return self;
}

- (void)setDelegate:(id<SlideshowViewControllerDelegate>)_delegate Type:(int)t
{
	lastPageNumber = 0;
	iOffSet = 0;
	iPhotoNumber = 21;
	controllerType = t;	
	indicatorArray = nil;
	videoViewController = nil;
	pictureViewController = nil;
	delegate = [_delegate retain];
}

- (id)initWithDelegate:(id<SlideshowViewControllerDelegate>)_delegate
{
	if (self = [super init])
    {
	    delegate = [_delegate retain];                
    }
    return self;
}

- (void)createSearchBar{
	
	int screenWidth = 1024;
	toolbar2 = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
	UIBarButtonItem *backButton;
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
		
	if(controllerType == SLIDESHOW_SERIESDETAILS){
		NSString *langCollection = [appDelegate getLocalTextString:@"view entire collection"];
	    backButton =[[UIBarButtonItem alloc]
								  initWithTitle:langCollection
								  style:UIBarButtonItemStyleBordered
								  target:self action:@selector(leftBarButtonAction:)];
	}else{
		backButton =[[UIBarButtonItem alloc]
									  initWithImage:[UIImage imageNamed:@"arrowLeft.png"]
									  style:UIBarButtonItemStylePlain
									  target:self action:@selector(leftBarButtonAction:)];
	}
	
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
		
	NSArray *newItems;
	if(controllerType == SLIDESHOW_SERIES){
	    newItems = [NSArray arrayWithObjects:leftSpace,rightSpace,searchItem,searchButton,nil];
	}else{
		newItems = [NSArray arrayWithObjects:backButton,leftSpace,rightSpace,searchItem,searchButton,nil];
	}
	
	[toolbar2 setItems:newItems];
	[searchButton release];	
	toolbar2.translucent = NO;
    toolbar2.barStyle = UIBarStyleBlack;
	
    [self.view addSubview:toolbar2];
	
}

- (void)createBottomBar{
	int fontSize = 16;
	int screenWidth = 1024;
	
	BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	if(appDelegate.adjustToolBar){
		
	    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 768-44-10, screenWidth, 44)];
	}else{
		toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 768-44, screenWidth, 44)];
	}	
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


- (void)infoButtonAction:(id)sender event:(id)event
{
	
	BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	int idx = 0;
	idx += iOffSet;
	NSString *infoText = [appDelegate getInfoTextbyIndex:idx];
		
#if USE_JKALERT	
	UIImage *backgroundImage = [UIImage imageNamed:@"infobox.png"];
	if([infoText length] > 5){
		UIAlertView* alert = [[JKCustomAlert alloc] initWithImage:backgroundImage 
					text:infoText];				
		[alert show];		
	}
#else
	if([infoText length] > 5){
		UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"" 
					 message:infoText 
					delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
#endif
	
}

- (void)loadView
{
	[super loadView];
		
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	if(controllerType != SLIDESHOW_BIGPICTURE){
		NSString *langBack = [appDelegate getLocalTextString:@"Back"];
	    _leftBarButton.title = langBack;
	}else{ 
		NSString *langCollection = [appDelegate getLocalTextString:@"view entire collection"];
		_leftBarButton.title = langCollection;
	}

#if OPTIMAZE_PAGING
	[self initPageViewController];
#else	

#endif
	[self reloadData];		
	
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	
#if DEBUG_LANDSCAPE	
#else
	[self createSearchBar];
#endif	
	
#if OPTIMAZE_PAGING
	
#endif		
	
}

- (void)viewDidUnload{
	if(slideshowView != nil){
        [slideshowView release];
        slideshowView = nil;
	}
}

- (void)initSeriesIndicator{
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;	
	screenWidth =  1024;
	screenHeight =  768;
	

   	if(controllerType == SLIDESHOW_BIGPICTURE){
		
		
		UIImage *infoline = [UIImage imageNamed:@"infoline.png"];
		int infoBarStartY = 768-68;
		UIImageView *infoImageView = [[UIImageView alloc] 
					  initWithFrame:CGRectMake(0, infoBarStartY, screenWidth+4, infoline.size.height-4) ];
		infoImageView.image = infoline;
		infoImageView.tag = INFOBBAR_VIEW;
		
		[self.view addSubview:infoImageView];   
		[self.view bringSubviewToFront:infoImageView];
		
		
		UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
		
		infoButton.frame = CGRectMake(screenWidth/2, infoBarStartY, infoButton.frame.size.width, infoButton.frame.size.height);
		[infoButton addTarget:self action:@selector(infoButtonAction:event:) forControlEvents:UIControlEventTouchUpInside];
		infoButton.tag = INFORBUTTON_VIEW;
		[self.view addSubview:infoButton];   
		[self.view bringSubviewToFront:infoButton];
	}else if(controllerType == SLIDESHOW_SERIESDETAILS){
		int count = [self.view.subviews count];
		for(int i = 0; i< count; i++){
			UIView *view = [self.view.subviews objectAtIndex:i];
			if(view.tag == INDICATOR_VIEW){
				return;
			}
		}	
		UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60,12)];
		myLabel.tag = INDICATOR_VIEW2;
		myLabel.text = @"    ";
		int savedIndicatorX = (screenWidth-250)/2;
		int savedIndicatorY = screenHeight-104; //screenHeight-74-30;
		myLabel.frame = CGRectMake(savedIndicatorX, savedIndicatorY, 50, 12);
		
		BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];	
		int currentSeries = appDelegate.currentSeries;	
		myLabel.backgroundColor = [appDelegate getColorByIndex:currentSeries];
		//
		NSArray *sorted = [self getSortedSeries];		
		
		NSString *sId  = [sorted objectAtIndex:currentSeries];	
		NSString *title = [appDelegate getSeriesNameByIndex:[sId intValue]];	
				
		[self.view addSubview:myLabel];   
		[self.view bringSubviewToFront:myLabel];
		UILabel *myTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200,32)];
		myTitle.tag = INDICATOR_VIEW;
		myTitle.text = title;
		myTitle.textColor = RGB(116, 116, 116);
		myTitle.font = [UIFont fontWithName:@"Arial" size: 16];
		myTitle.frame = CGRectMake(savedIndicatorX+90, savedIndicatorY-10, 200, 32);
		
		myTitle.backgroundColor = [UIColor clearColor];
		[self.view addSubview:myTitle];   
		[self.view bringSubviewToFront:myTitle];
		
		
	}
	
}

- (void)initSeriesViews{
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
		
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	
	screenWidth =  1024;
	screenHeight =  768;
	
#if DEBUG_LANDSCAPE	 
	return;
#endif
    
    isVisible = YES;
    if (dataReloadPending)
        [self reloadData];
	
	if (self.interfaceOrientation == UIInterfaceOrientationPortrait 
		||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		
	}
	
	CGRect mainframe = CGRectMake(0, 0, 1024, 768);
	
	self.view.frame = mainframe;	
	[self initSeriesIndicator];
	

	BACIAppDelegate* appDelegate = 
	  (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	
#if DEBUG_LANDSCAPE	 
	return;
#else	
	[self createBottomBar];
#endif
	
	//this code is exected to fix toolbar position.
	if(appDelegate.isInitToolBar){
		appDelegate.isInitToolBar = FALSE;
				
		IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];		
		int i, count = [appNavgitor.viewControllers count];
		for( i = 0; i< count; i++){			
			UIViewController* controller = [appNavgitor.viewControllers objectAtIndex:i];
			if(controller.view.tag == kTagSeriesView||
			   controller.view.tag == kTagSeriesDetailView||
			   controller.view.tag == kTagBigpictureView||
			   controller.view.tag == kTagThumbView){				
			    [controller viewWillDisappear:NO];
			    [controller.view removeFromSuperview];
			    [controller viewDidDisappear:NO];
			}
		}		
		
		[appDelegate showSeriesView:appDelegate.mainMenu];	
		
		[self reloadData];		
		pageControl.currentPage = 0;
		[self changePage:nil];		
	}
	
	if(appDelegate.adjustToolBar){
		appDelegate.adjustToolBar = FALSE;		
		CGRect mainframe = CGRectMake(0, -20, 1024, 768+20);
		self.view.frame = mainframe;
 		
	}
	
	if(controllerType == SLIDESHOW_SERIESDETAILS){
		 int currentSeries = appDelegate.currentSeries;	
		 NSArray *sorted = [self getSortedSeries];
		 int realIndex = currentSeries+iOffSet*3;
		 if(realIndex < [sorted count]){			 
			 NSString *sId  = [sorted objectAtIndex:realIndex];
			 int seriesId = [sId intValue];
			
			 int doneCount = 0;
			 int count = [self.view.subviews count];
			 for(int i = 0; i< count; i++){
				 if(doneCount >= 2) break;
				 UIView *view = [self.view.subviews objectAtIndex:i];
				 if(view.tag == INDICATOR_VIEW){					 
					 NSString *title = [appDelegate getSeriesNameByIndex:seriesId];						 
					 ((UILabel*)view).font = [UIFont fontWithName:@"Helvetica Neue" size: 16];				 
					 ((UILabel*)view).text = title;
					 ((UILabel*)view).textColor = RGB(116, 116, 116);
					 doneCount++;					 
				 }else if(view.tag == INDICATOR_VIEW2){					 				 
					 ((UILabel*)view).backgroundColor = [appDelegate getColorByIndex:seriesId];
					 doneCount++;
				 }
			 }
		 }else{
			 NSLog(@"ERROR,viewWillAppear,currentSeries:%d,realIndex:%d,iOffSet:%d",
				   currentSeries,realIndex,iOffSet);
		 }
		
		int page = lastPageNumber-1;
		if(page < 0) page  = 0;		
		pageControl.currentPage = page;
		[self changePage:nil];
	}
	
	//==
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
		UIButton *langLabel;
		if(controllerType == SLIDESHOW_SERIES){
			langLabel = (UIButton *)[[toolbar2.items objectAtIndex:3] customView];			
		}else{
			langLabel = (UIButton *)[[toolbar2.items objectAtIndex:4] customView];			
		}
				
		NSString *langSearch = [appDelegate getLocalTextString:@"Search"];
		[langLabel setTitle: langSearch forState: UIControlStateNormal];
		if(controllerType == SLIDESHOW_SERIESDETAILS){
			UIBarButtonItem *langLabel2 = (UIBarButtonItem *)[toolbar2.items objectAtIndex:0];
			NSString *langCollection = [appDelegate getLocalTextString:@"view entire collection"];
			langLabel2.title = langCollection;
		}		
	}
	
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    isVisible = NO;
    
}

- (void)dealloc
{
    [leftArrow release];
    [rightArrow release];
    [slideshowView release];
    [delegate release];	
#if OPTIMAZE_PAGING	
	[previousPage release];
	[currentPage release];
	[nextPage release];
#endif	

    [super dealloc];
}

#pragma mark -
#pragma mark Programming
- (int)getCurrentOffset{
#if OPTIMAZE_PAGING	
	return iOffSet;
#else
	return 0;
#endif
}

- (int)getTotalPhotoNumber{
	int n = [delegate slideshowViewControllerPhotosCount:self
										  ControllerType:controllerType];
	return n;
}

- (void)reloadData2:(int)index{
	isFirst = TRUE;
	isReachBorder = FALSE;
	
	int idx = index;
	int pageCount = [self getTotalPageCount:SLIDESHOW_SERIESDETAILS];
	
	selectedPhotoIndex = idx;		
	iOffSet = idx;
	currentNumber = idx;
	lastPageNumber = idx+1;		
	
	
	int	saveX = iOffSet;
	iOffSet--;
	if(iOffSet < 0) iOffSet = 0;
	previousPage.pageId = 0;
	[self doLoadData:previousPage];	
	[self applyNewIndex:currentNumber-1 pageController:previousPage];
	iOffSet = saveX;	
	
	saveX = iOffSet;
	currentPage.pageId = 1;
	[self doLoadData:currentPage];	
	[self applyNewIndex:currentNumber pageController:currentPage];	
	iOffSet = saveX;
			
	saveX = iOffSet;
	iOffSet++;		
	if(iOffSet < pageCount){
		nextPage.pageId = 2;
		[self doLoadData:nextPage];
		[self applyNewIndex:currentNumber+1 pageController:nextPage];
	}
	iOffSet = saveX;
	
	pageControl.currentPage = lastPageNumber-1;	
	[self changePage:nil];
	//[self showPhotoAtIndex:selectedPhotoIndex-1];
	
}

- (void)reloadData
{

	isFirst = TRUE;
	isReachBorder = FALSE;
	selectedPhotoIndex = 0;
	iOffSet = 0;
	
#if OPTIMAZE_PAGING	
	indicatorArray = nil;
	[self resetPageControl];
	[previousPage resetData];
	[currentPage resetData];
	[nextPage resetData];	
	int saveX = iOffSet;
	previousPage.pageId = 0;
	[self doLoadData:previousPage];
	[self applyNewIndex:0 pageController:previousPage];
	iOffSet++;
	currentPage.pageId = 1;
	[self doLoadData:currentPage];
	[self applyNewIndex:1 pageController:currentPage];
	iOffSet++;
	nextPage.pageId = 2;
	[self doLoadData:nextPage];
	[self applyNewIndex:2 pageController:nextPage];
	iOffSet = saveX;
#else
	[slideshowView resetData];	
	[self doLoadData:nil];
#endif	
		
	[self showFirstPage];	
	
	//----------------------------------------------------------------	
	if(controllerType == SLIDESHOW_BIGPICTURE){
		int n = [self getTotalPhotoNumber];
		if(indicatorArray != nil){
			[indicatorArray release];
			indicatorArray = nil;
		}
		indicatorArray = [[NSMutableArray alloc] initWithCapacity:n];
		for(int i = 0; i<n; i++){
			[indicatorArray addObject:[NSNumber numberWithInt:0]];
		}
	}
	//----------------------------------------------------------------
	
}

- (void)indicatorArraySet:(int)index Value:(int)v{
	[indicatorArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:v]];
}

- (int)indicatorAtArray:(int)index{
	NSNumber* indicator = (NSNumber*)[indicatorArray objectAtIndex:index];
	int value = [indicator intValue];
	return value;
}

- (int)findIndexBySeriesId:(int)sId{
	int result = 0;
	NSArray *sorted = [self getSortedSeries];		
	for (int i = 0; i < [sorted count]; ++i){
		NSString *strId  = [sorted objectAtIndex:i];
		if(sId == [strId intValue]){
			result = i;
			break;
		}
	}
	return result;
}

- (NSArray *)getSortedSeries{
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSArray *series = [appDelegate getCurrentSeriesIds];
	if(series == nil) return nil;
	int i = 0;
	NSMutableArray *intArray = [[NSMutableArray alloc] initWithCapacity:[series count]];
	for(i = 0; i < [series count]; i++){
		NSString *sId  = [series objectAtIndex:i];		    
		[intArray addObject:[NSNumber numberWithInt:[sId intValue]]];
	}
	NSArray *sorted = [intArray sortedArrayUsingSelector:@selector(compare:)];
    return 	sorted;
}

- (void)doLoadData:(PageViewController*)controller
{	
	
#if OPTIMAZE_PAGING	
	[controller resetData];  
#else
	[slideshowView resetData];
#endif
	
	int n = [self getTotalPhotoNumber];
		
	if (selectedPhotoIndex > n-1)
		selectedPhotoIndex = 0;
	
	[self didNavigate];
	
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];

	if(controllerType == SLIDESHOW_SERIES){
		NSArray *series = [appDelegate getCurrentSeriesIds];
		int iSeries = [series count];
		if(series == nil){
			iPhotoNumber = 0;
		}else {			
			if((iOffSet+1)*3 > iSeries){
				iPhotoNumber = iSeries-(iOffSet*3);
			}else{
				iPhotoNumber = 3;
			}
		}	
	}else if(controllerType == SLIDESHOW_SERIESDETAILS){
	    if((iOffSet+1)*3 > n){
			iPhotoNumber = n-(iOffSet*3);
		}else{
			iPhotoNumber = 3;
		}
	}else{
		iPhotoNumber = 1;
	}
	
	if(iPhotoNumber < 0)
		iPhotoNumber = 0;
	
#if OPTIMAZE_PAGING	

	if(controllerType == SLIDESHOW_SERIES||
	      controllerType == SLIDESHOW_SERIESDETAILS){
	    [controller setNumberOfPhotos:iPhotoNumber];
	}else if(controllerType == SLIDESHOW_BIGPICTURE){
		[controller setNumberOfPhotos:iPhotoNumber];
	}	
#else	
	iOffSet = 0;
	iPhotoNumber = n;
	[slideshowView setNumberOfPhotos:n];
#endif	
	NSLog(@"***doLoadData,iOffSet:%d photoNumber:%d",iOffSet,iPhotoNumber);			
	if(controllerType == SLIDESHOW_SERIES){		
		NSArray *sorted = [self getSortedSeries];		
		for (int i = 0; i < iPhotoNumber; ++i){
			int idx = i+iOffSet*3;
			NSString *sId  = [sorted objectAtIndex:idx];
			idx = [sId intValue]+1;
			
			NSString *location = [NSString stringWithFormat:@"%03d_F.jpg",idx];
			[delegate slideshowViewController:self fetchPhotoAtIndex:i Location:location Type:kTagSeriesView Page:controller.pageId];	
		}		
	}else if(controllerType == SLIDESHOW_SERIESDETAILS){
		int startId = [appDelegate getCurrentSeriesStartId:0];
		for (int i = 0; i < iPhotoNumber; ++i){
			#if OPTIMAZE_PAGING				
			    int idx = startId+i+iOffSet*3;
            #else
			    int idx = startId+i;//+1;
            #endif
			
			NSString *location = [NSString stringWithFormat:@"%@/368x436/%03d_F.jpg",@"Medium",idx];
			[delegate slideshowViewController:self fetchPhotoAtIndex:i Location:location Type:kTagSeriesDetailView Page:controller.pageId];
		}
	}else if(controllerType == SLIDESHOW_BIGPICTURE){
		int startId = [appDelegate getCurrentSeriesStartId:0];
		for (int i = 0; i < iPhotoNumber; ++i){			
			int idx = startId+i+iOffSet;			
			NSString *location = [NSString stringWithFormat:@"%@/368x436/%03d_F.jpg",@"Medium",idx];			
			[delegate slideshowViewController:self fetchPhotoAtIndex:i Location:location Type:kTagBigpictureView Page:controller.pageId];
		}
	}else{
		
	}	
	
	
}

- (void)showFullScreenPhoto:(NSString *)filename{
	if([filename length] == 0) return;
	if(pictureViewController != nil){
		pictureViewController = nil;
	}
	
	pictureViewController = [[PictureViewController alloc] initWithVideoFile:filename];
	pictureViewController.view.tag = kTagFullPhotoView;
			
	[self.navigationController presentModalViewController:pictureViewController animated:NO];
	[pictureViewController release];
	
}

- (void)playVideo:(NSString *)filename
{
			
	if(videoViewController != nil){		
		videoViewController = nil;		
	}
	
	videoViewController = [[VideoPlayViewController alloc] initWithVideoFile:filename];
	videoViewController.view.tag = kTagVideoView;		
		
	[self.navigationController presentModalViewController:videoViewController animated:NO];
	[videoViewController release];
	
}

- (void)fetchedPhoto:(UIImage *)photo atIndex:(int)index atPage:(int)page Location:(NSString *)location
{
#if	OPTIMAZE_PAGING
	int i = index;
	
	NSLog(@"fetchedPhoto:index:%d iOffSet:%d page:%d, location:%@",index,iOffSet,page,location);
	if(page == 0){
		[previousPage setPhoto:photo atIndex:i Location:location];
	}else if(page == 1){
		int saveX = iOffSet;
		if(iOffSet == 0) iOffSet = 1;
		[currentPage setPhoto:photo atIndex:i Location:location];
		iOffSet = saveX;
	}else if(page == 2){
		int saveX = iOffSet;
		if(iOffSet < 2) iOffSet = 2;
		[nextPage setPhoto:photo atIndex:i Location:location];
		iOffSet = saveX;
	}	
#else
    [slideshowView setPhoto:photo atIndex:index Location:nil];	
#endif
	
}

- (void)fetchedBigThumb:(UIImage *)photo atIndex:(int)index atPage:(int)page type:(int)t{
	int idx = index; // - iOffSet;
	if(page == 0){
		[previousPage setBigThumbPhoto:photo atIndex:idx type:t];
	}else if(page == 1){
		[currentPage setBigThumbPhoto:photo atIndex:idx type:t];
	}else if(page == 2){
		[nextPage setBigThumbPhoto:photo atIndex:idx type:t];
	}
}

- (void)showPhotoAtIndex:(int)index
{
    selectedPhotoIndex = index;
#if	OPTIMAZE_PAGING
	int i = index;
	if(controllerType == SLIDESHOW_SERIESDETAILS){
	    i = index - iOffSet;
    }else if(controllerType == SLIDESHOW_BIGPICTURE){
		iOffSet = index;
		pageControl.currentPage = index+1;
		[self changePage:nil];
	}else{		
		i = index;// - iOffSet;
	}
	
	[currentPage showPhotoAtIndex:i];

#else	
    [slideshowView showPhotoAtIndex:index];
#endif	
}

- (void)didNavigate
{
	
}

- (void)showPrevPhoto
{
    --selectedPhotoIndex;
    [self didNavigate];
    [slideshowView showPhotoAtIndex:selectedPhotoIndex];
}


- (void)showNextPhoto
{
   // ++selectedPhotoIndex;
    [self didNavigate];   
		
}

- (BOOL)reloadDataIfNeeded:(int)index{
 	int n = [delegate slideshowViewControllerPhotosCount:
			 self ControllerType:controllerType];
	
	int check = index;//+2;
	if(iOffSet <= index && check<= (iOffSet+iPhotoNumber-1)){
		
		selectedPhotoIndex = index;
		[self didNavigate];
		return FALSE;		
	}
	
	if((selectedPhotoIndex+2) >= index){
		
		if((iOffSet + 21) >= n){			
			selectedPhotoIndex = index;
			[self didNavigate];
			return FALSE;
		}
		iOffSet += 21;
		if((iOffSet + 42) >= n){				
			iPhotoNumber = (n - iOffSet-21);
		}else{
			iPhotoNumber = 21;			
		}		
		if(iOffSet > n-1||iPhotoNumber <= 0){			
			selectedPhotoIndex = index;
			[self didNavigate];
			return FALSE;
		}
	}else{
		if((iOffSet - 21) >= 0){
			iOffSet -= 21;
			iPhotoNumber = 21;
		}else{
			iOffSet = 0;
			iPhotoNumber = iOffSet-21;
		}
		if(iOffSet <= 0||iPhotoNumber <= 0){
			iOffSet = 0;
			iPhotoNumber = 0;
			selectedPhotoIndex = index;
			[self didNavigate];
			return FALSE;
		}
	}
    	  
	[self doLoadData:nil];
	
	return TRUE;
}

- (void)scrolledToIndex:(int)index
{
	int n = [delegate slideshowViewControllerPhotosCount:self ControllerType:controllerType];
	if(index < 0 || index > n-1){		
		return;
	}		
	
	 selectedPhotoIndex = index;
    [self didNavigate];	
	
}

#pragma mark -
#pragma mark Public

-(IBAction)leftBarButtonAction:(id)sender{
	
	if(controllerType == SLIDESHOW_SERIES){		
		BACIAppDelegate* appDelegate = 
		(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
		IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
		
		int i, count = [appNavgitor.viewControllers count];
		for( i = 0; i< count; i++){			
			UIViewController* controller = [appNavgitor.viewControllers objectAtIndex:i];
			if(controller.view.tag == kTagMainmenuView||
			   controller.view.tag == kTagSeriesView||
			   controller.view.tag == kTagSeriesDetailView||
			   controller.view.tag == kTagBigpictureView||
			   controller.view.tag == kTagThumbView){				
			    [controller viewWillDisappear:NO];
			    [controller.view removeFromSuperview];
			    [controller viewDidDisappear:NO];
			}
		}
		[appDelegate showMainmenuView];
	}else if(controllerType == SLIDESHOW_BIGPICTURE){
		
		BACIAppDelegate* appDelegate = 
		  (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
		IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
		
		int i, count = [appNavgitor.viewControllers count];
		for( i = 0; i< count; i++){
			
			UIViewController* controller = [appNavgitor.viewControllers objectAtIndex:i];
			if(controller.view.tag == kTagSeriesView||
			   controller.view.tag == kTagSeriesDetailView||
			   controller.view.tag == kTagBigpictureView||
			   controller.view.tag == kTagThumbView){
				
				[controller viewWillDisappear:NO];
				[controller.view removeFromSuperview];
				[controller viewDidDisappear:NO];
			}			
		}	
		
		
		if(fromBigType == kTagSeriesDetailView){
		    [appDelegate showSeriesDetailView:appDelegate.currentSeries fromType:kTagBigpictureView];
		}else if(fromBigType == kTagThumbView){
			[appDelegate showThumbs:appDelegate.mainMenu];
		}
		
	}else if(controllerType == SLIDESHOW_SERIESDETAILS){
		
		BACIAppDelegate* appDelegate =
		  (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];		
		[appDelegate showThumbs:appDelegate.mainMenu];
	}
}

-(IBAction)doSearch:(id)sender{
	
	UISearchBar* searchBar;
	if(controllerType == SLIDESHOW_SERIES){
		searchBar = (UISearchBar *)[[toolbar2.items objectAtIndex:2] customView];			
	}else{
		searchBar = (UISearchBar *)[[toolbar2.items objectAtIndex:3] customView];			
	}
	NSString *text = searchBar.text;
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate doSearch:text];
	
}

-(void)backToSeries{
	BOOL find = FALSE;
	int i = 0;	
	BACIAppDelegate* appDelegate = 
	   (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	IPhotoGallery* appNavgitor = [appDelegate getPhotoGallery];
		
	for (i = 0; i < [appNavgitor.viewControllers count]; i++) {
		UIViewController* controller = 
		[appNavgitor.viewControllers objectAtIndex:i];				
		if ([controller isKindOfClass:[SlideshowViewController class]]) {
			find = TRUE;
			break;
		}
	}	
	if(find){
		[appNavgitor popToViewController:
		 [appNavgitor.viewControllers objectAtIndex:i] animated:YES];
	}
}

- (void)resetAllViews{
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
			     controller.view.tag == kTagThumbView){				 
			    [controller viewWillDisappear:NO];
			    [controller.view removeFromSuperview];
			    [controller viewDidDisappear:NO];
			}
		}
		
		[appDelegate showSeriesView:LINGERIE];
	}
}

-(IBAction)goEYELASHES:(id)sender{
	
	BOOL popViews = FALSE;
	UIButton *langLabel = (UIButton *)[[toolbar.items objectAtIndex:2] customView];
	[langLabel setSelected:YES];
	
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
			   controller.view.tag == kTagThumbView){				
			    [controller viewWillDisappear:NO];
			    [controller.view removeFromSuperview];
			    [controller viewDidDisappear:NO];
			}
		}
				
		[appDelegate showSeriesView:EYELASHES];
	}
}

-(IBAction)goCATEGORIES:(id)sender{
		BOOL popViews = FALSE;
	UIButton *langLabel = (UIButton *)[[toolbar.items objectAtIndex:3] customView];
	[langLabel setSelected:YES];
	
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
			   controller.view.tag == kTagThumbView){				
			    [controller viewWillDisappear:NO];
			    [controller.view removeFromSuperview];
			    [controller viewDidDisappear:NO];
			}
		}
				
		[appDelegate showSeriesView:CATEGORIES];
	}
	
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
#pragma mark Paging
- (void)showFirstPage{
	pageControl.currentPage = 0;
	[self changePage:nil];
}

- (void)adjustLastPageFromBigView:(int)index{
	int t = [self getTotalPageCount:controllerType];
	if((t-1)*3 <= index){		
		pageControl.currentPage = t-1;
		[self changePage:nil];
	}
}

- (int)getTotalPageCount:(int)t{
	int widthCount = 0;
	int n = [self getTotalPhotoNumber];
	if(t == SLIDESHOW_SERIES||
	   t == SLIDESHOW_SERIESDETAILS){
		widthCount = n/3;
		if(n%3 > 0){
			widthCount++;
		}
	}else{
		widthCount = n;
	}	
	if (widthCount == 0)
	{
		widthCount = 1;
	}
	
	return widthCount;
}

- (void)initPageViewController
{
	
	previousPage = [[PageViewController alloc] initWithParentViewController:self Type:controllerType];
	currentPage = [[PageViewController alloc] initWithParentViewController:self Type:controllerType];
	nextPage = [[PageViewController alloc] initWithParentViewController:self Type:controllerType];
	previousPage.pageId = 0;
	currentPage.pageId = 1;
	nextPage.pageId = 2;
	
	[scrollView addSubview:previousPage.view];
	[scrollView addSubview:currentPage.view];
	[scrollView addSubview:nextPage.view];
	pageControl.hidden = YES;
	
	
	NSInteger widthCount = [self getTotalPageCount:controllerType];//+1;
		
    scrollView.contentSize =
	CGSizeMake(
			   scrollView.frame.size.width * widthCount,
			   scrollView.frame.size.height);
	scrollView.contentOffset = CGPointMake(0, 0);
	
	pageControl.numberOfPages = widthCount;
	
	pageControl.currentPage = 0;
	
	[self applyNewIndex:0 pageController:previousPage];
	[self applyNewIndex:1 pageController:currentPage];
	[self applyNewIndex:2 pageController:nextPage];
		
	
	CGRect frame = scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
	
}

- (void)resetPageControl{
	
	NSInteger widthCount = [self getTotalPageCount:controllerType];//+1;
	
    scrollView.contentSize =
	CGSizeMake(
			   scrollView.frame.size.width * widthCount,
			   scrollView.frame.size.height);
	scrollView.contentOffset = CGPointMake(0, 0);
	
	pageControl.numberOfPages = widthCount;	
	pageControl.currentPage = 0;
	
	CGRect frame = scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
	
}

- (void)applyNewIndex:(NSInteger)newIndex pageController:(PageViewController *)pageController
{
	
	NSInteger pageCount = [self getTotalPageCount:controllerType];
	BOOL outOfBounds = newIndex >= pageCount || newIndex < 0;
	
	if (!outOfBounds)
	{
		CGRect pageFrame = pageController.view.frame;
		pageFrame.origin.y = 0;
		pageFrame.origin.x = scrollView.frame.size.width * newIndex;
		pageController.view.frame = pageFrame;		
	}
	else
	{
		
	}	
	pageController.pageIndex = newIndex;
	
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
	
	 currentNumber = floor(fractionalPage);
	
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
	NSInteger nearestNumber = lround(fractionalPage);
	
	
	[self doScrollViewDidEndScrolling];	
}

- (void)resetPageOrder{
	previousPage.pageId = 0;
	currentPage.pageId = 1;
	nextPage.pageId = 2;
}

- (void)doScrollViewDidEndScrolling{
	int loadCurrent = fabs(currentNumber-currentPage.pageIndex);
	if(isFirst){
		if(currentNumber < 2){
			iOffSet = currentNumber;
			lastPageNumber = currentNumber+1;
			
			return;
		}else{
			isFirst = FALSE;
		}
	}	
	
	int pageCount = [self getTotalPageCount:controllerType];
	if(isReachBorder){
		if(currentNumber == 0||currentNumber == 1||
		   currentNumber == pageCount-2||
		   currentNumber == pageCount-1){
			iOffSet = currentNumber;
			previousPage.pageIndex = currentNumber-1;
			currentPage.pageIndex = currentNumber;
			nextPage.pageIndex = currentNumber+1;
			
			if(iOffSet == 1){
				if(controllerType == SLIDESHOW_SERIES){
					[currentPage adjustStrangeScap];		
				}
			}
		    return;
		}
	}
	iOffSet = currentNumber;	
	if((currentNumber-1) == 0||(currentNumber+1) == pageCount-1){		
		isReachBorder = TRUE;
	}else{
		isReachBorder = FALSE;
	}
	
	
	if(currentNumber >= 0 && currentNumber <= pageCount-1){
		//lastPageNumber = currentNumber+1;
	}else{
		return;
	}
	
	BOOL left = FALSE;
	if(lastPageNumber <= (currentNumber+1)){
		left = TRUE;
				
		PageViewController *swapController = currentPage;
		currentPage = previousPage;
		previousPage = swapController;		
		[self applyNewIndex:currentNumber-1 pageController:previousPage];
		
		swapController = nextPage;
		nextPage = currentPage;
		currentPage = swapController;
		[self applyNewIndex:currentNumber pageController:currentPage];
		{
			int	saveX = iOffSet;
			iOffSet++;		
			if(iOffSet < pageCount){
				nextPage.pageId = 2;
				[self doLoadData:nextPage];
				[self applyNewIndex:currentNumber+1 pageController:nextPage];
				[nextPage updateTextViews:YES];
			}
			iOffSet = saveX;			
		}			
	}else{
			
		PageViewController *swapController = currentPage;
		currentPage = nextPage;
		nextPage = swapController;
		[self applyNewIndex:currentNumber+1 pageController:nextPage];
				
		swapController = previousPage;
		previousPage = currentPage;
		currentPage = swapController;
		[self applyNewIndex:currentNumber pageController:currentPage];
		
		{
			int saveX = iOffSet;
			iOffSet--;
			if(iOffSet >= 0){
				previousPage.pageId = 0; //nextPage??
				[self doLoadData:previousPage];
				[self applyNewIndex:currentNumber-1 pageController:previousPage];
				[previousPage updateTextViews:YES];
			}			
			iOffSet = saveX;		    
			
		}		
	}
	

	if(loadCurrent > 1){
		if(currentNumber == 0){
		  
		}
		if(currentNumber >= 0 && currentNumber <= pageCount-1){
			currentPage.pageId = 1; 
		   [self doLoadData:currentPage];
		   [self applyNewIndex:currentNumber pageController:currentPage];
		}
		if(left){
			int saveX = iOffSet;
			iOffSet--;
			if(iOffSet >= 0){
				previousPage.pageId = 0; 
				[self doLoadData:previousPage];
				[self applyNewIndex:currentNumber-1 pageController:previousPage];
				[previousPage updateTextViews:YES];
			}
			iOffSet = saveX;			
		}else{
			int	saveX = iOffSet;
			iOffSet++;		
			if(iOffSet < pageCount){
				nextPage.pageId = 2; 
				[self doLoadData:nextPage];
				[self applyNewIndex:currentNumber+1 pageController:nextPage];
				[nextPage updateTextViews:YES];
			}
			iOffSet = saveX;			
		}		
	}
		
	lastPageNumber = currentNumber+1; //currentPage.pageIndex;	
	if(iOffSet == 1){
		if(controllerType == SLIDESHOW_SERIES){
			[currentPage adjustStrangeScap];		
		}
	}
	
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
	[self scrollViewDidEndScrollingAnimation:newScrollView];
	pageControl.currentPage = currentPage.pageIndex;
}

- (IBAction)changePage:(id)sender
{
		
	NSInteger pageIndex = pageControl.currentPage;
			
	// update the scroll view to the appropriate page
	CGRect frame = scrollView.frame;
	frame.origin.x = frame.size.width * pageIndex;
	frame.origin.y = 0;
	[scrollView scrollRectToVisible:frame animated:NO];
    
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
       
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
		     orientation == UIInterfaceOrientationLandscapeRight) {
        
        //Do Your Landscape Changes here		
		CGRect mainframe = CGRectMake(0, 0, 1024, 768);
		self.view.frame = mainframe;
    }
    else if (orientation == UIInterfaceOrientationPortrait ||
			 orientation == UIInterfaceOrientationPortraitUpsideDown) {        
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
