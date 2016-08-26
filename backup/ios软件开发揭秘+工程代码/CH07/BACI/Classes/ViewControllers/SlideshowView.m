//
//  SlideshowView.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import "SlideshowView.h"
#import "PageViewController.h"
#import "LayoutManagers.h"
#import "TouchableView.h"
#import "BACIAppDelegate.h"
#import "IPhotoGallery.h"
#import "Constants.h"

#define PHOTO_SPACING 20
#define SPINNER_WIDTH 20

#define THUMB_WIDTH (41)
#define THUMB_HEIGHT (55)
#define FIX_BARS_HEIGHT 108

#define MAIN_PIC_VIEW     100
#define FRONT_THUMB_VIEW  101
#define BACK_THUMB_VIEW   102
#define VIDEO_THUMB_VIEW  103
#define FRONT_BORDER_VIEW 104
#define BACK_BORDER_VIEW  105

@implementation SlideshowView

@synthesize controllerType;
@synthesize controller;
@synthesize thumbIndex;
@synthesize currentIndex;
@synthesize numberOfPhoto;
@synthesize boundsSizeWidth;
@synthesize savedIndicatorX,savedIndicatorY;

- (id)initWithFrame:(CGRect)frame controller:(PageViewController *)c Type:(int)t
{
    if (self = [super initWithFrame:frame])
    {
		thumbIndex = 0;
		savedIndicatorX = 0;
		savedIndicatorY = 0;
        controller = c;
        controllerType = t;
				
        self.backgroundColor = [UIColor clearColor];				
    }
    return self;
}

- (void)resetData{
	isBlack = FALSE;
	thumbIndex = 0;	
	currentIndex = 0;
	savedIndicatorX = 0;
	savedIndicatorY = 0;
}

- (void)dealloc
{
    [photoContainers release];
    [mainLayout release];
	
    [super dealloc];
}


- (void)setNumberOfPhotos:(int)n
{
    [mainLayout removeFromSuperview];
    [mainLayout release];
	numberOfPhoto = n;

	//CGRect bounds = [[UIScreen mainScreen] bounds];
	//int screenWidth =  bounds.size.width;
	//int screenHeight =  bounds.size.height;
	int screenWidth =  1024; 
	int screenHeight =  768;
#if DEBUG_LANDSCAPE
	if(screenHeight == 768)
		return;
#endif
		
    mainLayout = [[HLayoutView alloc] initWithFrame:
                  CGRectMake(-PHOTO_SPACING/2, 0, 
							 screenWidth + PHOTO_SPACING, screenHeight)
                  spacing:PHOTO_SPACING
                  leftMargin:PHOTO_SPACING/2 rightMargin:PHOTO_SPACING/2
                  topMargin:0 bottomMargin:0
                  hAlignment:UIControlContentHorizontalAlignmentLeft
                  vAlignment:UIControlContentVerticalAlignmentTop];
    mainLayout.scrollEnabled = NO;
    mainLayout.pagingEnabled = NO;
    mainLayout.showsHorizontalScrollIndicator = NO;
    mainLayout.showsVerticalScrollIndicator = NO;
    mainLayout.delegate = self;
		
    [self addSubview:mainLayout];
    [photoContainers release];
    photoContainers = [[NSMutableArray alloc] initWithCapacity:n];
		
	if(controllerType != SLIDESHOW_BIGPICTURE){		
		//screenWidth = (screenWidth + PHOTO_SPACING)/3; 
		screenWidth = 341;//screenWidth/3;
	}
	
	screenHeight -= FIX_BARS_HEIGHT;
	
#if OPTIMAZE_PAGING
	if(n < 3){
		if(controllerType != SLIDESHOW_SERIES){	
		  n = 3;
		}
	}
#endif
	
    for (int i = 0; i < n; ++i)
    {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  [NSNumber numberWithInt:i] forKey:@"index"];
		UIView *container;
		if(controllerType == SLIDESHOW_BIGPICTURE){             			 
			//change to full screen picture.
			container = [[TouchableView alloc] initWithFrame:
						 CGRectMake(0, 0, screenWidth, screenHeight)
													  target:self userInfo:userInfo];
			((TouchableView*)container).touchesEndedSelector = @selector(goFullScreen:);
			container.backgroundColor = [UIColor clearColor];			
		}else{
					
			container = [[TouchableView alloc] initWithFrame:
                  CGRectMake(0, 0, screenWidth, screenHeight)
					 target:self userInfo:userInfo];
			((TouchableView*)container).touchesEndedSelector = @selector(goBigTapped:);
			container.backgroundColor = [UIColor clearColor];			
		}        
		
        [mainLayout addSubview:container];
        [container release];
        [container addSubview:[self loadingIndicatorView]];				
		
        [photoContainers addObject:container];
    }
    // force layout, because -showPhotoAtIndex: can be called before displaying
    [mainLayout layoutSubviews];
}

- (void)goFullScreen:(NSDictionary *)userInfo{
	int idx = [[userInfo objectForKey:@"index"] intValue];
		
	BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	idx += [controller getCurrentOffset];
	
	NSString* filename = [appDelegate getBigPictureNamebyIndex:idx Selection:isBlack];
	
	[controller showFullScreenPhoto:filename];
	
}

- (void)goBigTapped:(NSDictionary *)userInfo
{
    
	int idx = [[userInfo objectForKey:@"index"] intValue];
	BACIAppDelegate* appDelegate = 
	     (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
				
	if(controllerType == SLIDESHOW_SERIES){	
       #if OPTIMAZE_PAGING			
		    int iOffSet = [controller getCurrentOffset];
		    if(iOffSet < 0) iOffSet = 0;
		    idx = idx + iOffSet*3;
       #endif		
		 appDelegate.currentSeries = idx;       
	    [appDelegate showSeriesDetailView:idx fromType:kTagSeriesView];
	}else if(controllerType == SLIDESHOW_SERIESDETAILS){		
        #if OPTIMAZE_PAGING
		  int iOffSet = [controller getCurrentOffset];//-1;	
		  if(iOffSet < 0) iOffSet = 0;
		  idx += iOffSet*3; 
		  NSLog(@"3,***goBigTapped:%d,iOffSet:%d",idx,iOffSet);
        #endif		
	 	appDelegate.savedSeriesDetailIndex = idx;//currentIndex;		
	    [appDelegate showBigPictureView:idx fromType:kTagSeriesDetailView];	
	}else{
		//should never be called.
		[appDelegate showBigPictureView:idx fromType:kTagBigpictureView];
	}	

}


- (void)infoButtonAction:(id)sender event:(id)event
{
	UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"B.A.C.I" 
	   message:@"some information about this product\n\n please contact us.\n" 
	   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)setPhoto:(UIImage *)photo atIndex:(int)index Location:(NSString *)location
{
	//CGRect sbounds = [[UIScreen mainScreen] bounds];
	//float screenWidth =  sbounds.size.width;
	//float screenHeight =  sbounds.size.height;
	int screenWidth =  1024; 
	int screenHeight =  768;
	
#if DEBUG_LANDSCAPE
	if(screenHeight == 768)
		return;
#endif
	
	if(controllerType != SLIDESHOW_BIGPICTURE){		
		//screenWidth = (screenWidth + PHOTO_SPACING)/3; 
		screenWidth = 341;//screenWidth/3; 
	}
	
	screenHeight -= FIX_BARS_HEIGHT;
	
	//remove subviews 	
    UIView *photoContainer = [photoContainers objectAtIndex:index];
    UIView *loadingIndicator = [photoContainer.subviews lastObject];
    [loadingIndicator removeFromSuperview];
    float width = photo.size.width;
    float height = photo.size.height;

#if PHOTO_FIT_BACI	
    float widthRatio = screenWidth / width;
    float heightRatio = screenHeight / height;
    if (widthRatio < heightRatio)
    {
        width *= widthRatio;
        height *= widthRatio;
    }
    else
    {
        width *= heightRatio;
        height *= heightRatio;
    }
#endif
		
	
	int theImageX = (screenWidth - width) / 2;
	int theImageY = (screenHeight - height) / 2+22;
	if(controllerType == SLIDESHOW_BIGPICTURE){
		theImageY += 44;		
		self.center = CGPointMake(1024/2, 768/2-20); 
	}else{
		theImageY += 24;
	}
	
	BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	int iMagic = 22;
	int iHeight = 0;
	if(appDelegate.mainMenu == EYELASHES){
		if(controllerType != SLIDESHOW_BIGPICTURE){
		   iMagic = 62;
		}else{
		   iMagic = 42;
		   iHeight = 54;
		}
	}else{
		if(controllerType != SLIDESHOW_BIGPICTURE){
			iMagic = 72;
		}else{
			iMagic = 42;
			iHeight = 54;
		}
	}
	
#if PHOTO_FIT_BACI		
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake((screenWidth - width) / 2, 
										 (screenHeight - height) / 2+iMagic,
                                         width, height-iMagic-iHeight)];
	
#else
	if(controllerType == SLIDESHOW_BIGPICTURE){
		theImageY -= 20;
	}
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(theImageX, theImageY,
                                         width, height)];
	
#endif
	
	imageView.tag = MAIN_PIC_VIEW;
	
	if(controllerType == SLIDESHOW_BIGPICTURE){		
	    //CGSize iSize  = CGSizeMake(width, height-iMagic);
		imageView.image = photo;
	}else{	
		if(controllerType == SLIDESHOW_SERIES){
			CGSize iSize  = CGSizeMake(368,436);
			imageView.image = [self resizeImage:photo scaledToSize:iSize];			
		}else{
			imageView.image = photo; 
		}
	}
    
	imageView.backgroundColor = [UIColor clearColor];
    [photoContainer addSubview:imageView];

	CGRect bounds = [imageView bounds];
	boundsSizeWidth = bounds.size.width;

	int thumb_width = THUMB_WIDTH, thumb_height = THUMB_HEIGHT;
	if(controllerType != SLIDESHOW_BIGPICTURE){
		thumb_width = THUMB_WIDTH/2;
		thumb_height = THUMB_HEIGHT/2;
	}

#if NETWORK_SUPPORT_MOVIE_ONLY	
	UIImage *stretchImage, *stretchImage2, *stretchImage3;
	CGSize size  = CGSizeMake(thumb_height, thumb_width);
#endif	
	int thumbStartX = (screenWidth-bounds.size.width)/2+bounds.size.width-thumb_width*3-10;
		
	int thumbStartY = 0;
	if(appDelegate.mainMenu == EYELASHES){
		thumb_width = 53;
		thumb_height = 42;
		thumbStartX = (screenWidth-bounds.size.width)/2+bounds.size.width/2-(thumb_width*3)/2;		
		thumbStartY = screenHeight-44;
	}else{
		thumbStartX = (screenWidth-bounds.size.width)/2+bounds.size.width/2-(thumb_width*3+60)/2;	
		thumbStartY = screenHeight-44-20;		
	}
		
	if(controllerType == SLIDESHOW_BIGPICTURE){		
		int idx = index;
		if(controllerType == SLIDESHOW_BIGPICTURE){
			idx += [controller getCurrentOffset];
		}else{
			idx += [controller getCurrentOffset]*3;
		}
		
	
		stretchImage3 = [appDelegate getMovieThumbImage:idx];	
		if(appDelegate.mainMenu == EYELASHES){
			if(stretchImage3 == nil)
			  stretchImage3 = [UIImage imageNamed:@"video.png"];			
		}else{
			if(stretchImage3 == nil){
				UIImage *origImage3 = [UIImage imageNamed:@"001_bl214wht.jpg"];			   			
			    stretchImage3 = [self resizeImage:origImage3 scaledToSize:size];
			}			
		}		
		
		[self setBigThumbPhoto:stretchImage3 atIndex:index type:3];				
		
	}else{
		if(controllerType == SLIDESHOW_SERIESDETAILS){
			[imageView release];
			return;
		}
		
		if(savedIndicatorX == 0)
			savedIndicatorX = theImageX; 
		if(savedIndicatorY == 0){			
			savedIndicatorY = screenHeight-62;
		}
		UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60,12)];
		myLabel.text = @"    ";		
		myLabel.frame = CGRectMake(savedIndicatorX, savedIndicatorY, 50, 12);
		
        NSString *title = @"";
        #if OPTIMAZE_PAGING
			NSArray *sorted = [controller getSortedSeries];
		    int realIndex = index+[controller getCurrentOffset]*3;		
		    if(realIndex < [sorted count]){						
				NSString *sId  = [sorted objectAtIndex:realIndex];		    
				title = [appDelegate getSeriesNameByIndex:[sId intValue]];				
				myLabel.backgroundColor = [appDelegate getColorByIndex:[sId intValue]];
		    }else{				
				return;
			}
        #else
		    title = [appDelegate getSeriesNameByIndex:index];
		    myLabel.backgroundColor = [appDelegate getColorByIndex:index];
        #endif
	
		myLabel.font = [UIFont fontWithName:@"Arial" size: 16];
	    
		if(appDelegate.mainMenu == EYELASHES && index == 2){
			 UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GLAMOUR.jpg"]];
			 tempImageView.frame = CGRectMake(savedIndicatorX, savedIndicatorY, 50, 12);
			 [photoContainer addSubview:tempImageView];
			 [photoContainer bringSubviewToFront:tempImageView];
		}else{
			
			[photoContainer addSubview:myLabel];
		}
				
		UILabel *myTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300,32)];
		if(controllerType == SLIDESHOW_SERIESDETAILS){
		    myTitle.text = @"";
		}else{
			myTitle.text = title; 
			myTitle.textColor = RGB(116, 116, 116);
		}		
		
		myTitle.frame = CGRectMake(savedIndicatorX+90, savedIndicatorY-10, 300, 32);
		myTitle.font = [UIFont fontWithName:@"Helvetica Neue" size: 16];
		myTitle.backgroundColor = [UIColor clearColor];
		[photoContainer addSubview:myTitle];
		
		[imageView release];
		return;
	}
	
	NSArray *strings = [location componentsSeparatedByString: @"/"];
	NSString *photoFileName = [strings objectAtIndex:[strings count]-1];
	    
	NSString *strIndex = [photoFileName substringToIndex:[photoFileName length]-6];
	NSString *location1 = [NSString stringWithFormat:@"%@/41x55/%@_B.jpg",@"Thumbs",strIndex];
	NSString *location2 = [NSString stringWithFormat:@"%@/41x55/%@_F.jpg",@"Thumbs",strIndex];
			
	stretchImage = [appDelegate getLocalImageAtIndex:index Location:location1];
	stretchImage2 = [appDelegate getLocalImageAtIndex:index Location:location2];
	if(stretchImage == nil)
		stretchImage = [UIImage imageNamed:@"eye2.png"];
	[self setBigThumbPhoto:stretchImage atIndex:index type:1];
	if(stretchImage2 == nil)
		stretchImage2 = [UIImage imageNamed:@"eye.png"];
	[self setBigThumbPhoto:stretchImage2 atIndex:index type:2];
			
	[imageView release];	
	
}

- (void)setBigThumbPhoto:(UIImage *)photo atIndex:(int)index type:(int)t{
	
	int screenWidth =  1024; 
	int screenHeight =  768;
		
	if(controllerType != SLIDESHOW_BIGPICTURE){		
		//screenWidth = (screenWidth + PHOTO_SPACING)/3; 
		screenWidth = 341;//screenWidth/3; 
	}
	
	screenHeight -= FIX_BARS_HEIGHT;
	
	//for big view only have one picture.	
 	UIView *photoContainer = [photoContainers objectAtIndex:0];
			
	BACIAppDelegate* appDelegate = 
	(BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	int iMagic = 22;
	int iHeight = 0;
	if(appDelegate.mainMenu == EYELASHES){
		if(controllerType != SLIDESHOW_BIGPICTURE){
			iMagic = 62;
		}else{
			iMagic = 42;
			iHeight = 54;
		}
	}else{
		if(controllerType != SLIDESHOW_BIGPICTURE){
			iMagic = 72;
		}else{
			iMagic = 42;
			iHeight = 54;
		}
	}
			
	int thumb_width = THUMB_WIDTH, thumb_height = THUMB_HEIGHT;
	if(controllerType != SLIDESHOW_BIGPICTURE){
		thumb_width = THUMB_WIDTH/2;
		thumb_height = THUMB_HEIGHT/2;
	}
	
	CGSize size  = CGSizeMake(thumb_height, thumb_width);
	//int thumbStartX = (screenWidth-THUMB_WIDTH*3-10)/2;
	int thumbStartX = (screenWidth-boundsSizeWidth)/2+boundsSizeWidth-thumb_width*3-10;
	
	int thumbStartY = 0;
	if(appDelegate.mainMenu == EYELASHES){		
		thumb_width = 53;
		thumb_height = 42;
		thumbStartX = (screenWidth-boundsSizeWidth)/2+boundsSizeWidth/2-(thumb_width*3)/2;		
		thumbStartY = screenHeight-44;
	}else{
		thumbStartX = (screenWidth-boundsSizeWidth)/2+boundsSizeWidth/2-(thumb_width*3+60)/2;	
		thumbStartY = screenHeight-44-20;			
	}
	
	//-------------------------------------------	
	if(isBlack){	
		if(t == 2){
#if OPTIMAZE_PAGING
			int idx2 = index;	
			[controller indicatorArraySet:idx2 Value:1];
#else
			[controller indicatorArraySet:index Value:1];
#endif
		}
	}else{	
		if(t == 1){
#if OPTIMAZE_PAGING
			int idx2 = index;			
			[controller indicatorArraySet:idx2 Value:0];
#else
			[controller indicatorArraySet:index Value:0];
#endif
		}//t=1
	}
	 
	//-------------------------------------------------------------
	
	if(controllerType == SLIDESHOW_BIGPICTURE){
		if(t == 3){
			UIView *videoButtonView = [self findSubViewByTag:photoContainer Tag:502];
			if(videoButtonView == nil){
				UIButton *imageButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
						
				if(appDelegate.mainMenu == EYELASHES){
					if(photo == nil)
						photo = [UIImage imageNamed:@"video.png"];
					imageButton3.frame = CGRectMake(thumbStartX+thumb_width*2+10, thumbStartY-10, photo.size.width, photo.size.height);
				}else{
					if(photo == nil){
						UIImage *origImage3 = [UIImage imageNamed:@"001_bl214wht.jpg"];			   			
						photo = [self resizeImage:origImage3 scaledToSize:size];
					}
					imageButton3.frame = CGRectMake(thumbStartX+thumb_width*2+80, thumbStartY, thumb_width, thumb_height);
				}		
				
				[imageButton3 setImage:photo forState:UIControlStateNormal];
				imageButton3.adjustsImageWhenHighlighted = NO;
				[imageButton3 addTarget:self action:@selector(thumbTapped:event:) forControlEvents:UIControlEventTouchUpInside];
				imageButton3.tag = 502;
				[photoContainer addSubview:imageButton3];   
				[photoContainer bringSubviewToFront:imageButton3];	
			}else{
				[photoContainer bringSubviewToFront:videoButtonView];	
			}
		}
	}else{
		//
		return;
	}
			
	//----------------------------------------------------------------------------
	if(t == 1){
			UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];			
			if(appDelegate.mainMenu == LINGERIE||
			   appDelegate.mainMenu == CATEGORIES){
				imageButton.frame = CGRectMake(thumbStartX+thumb_width+30, thumbStartY, photo.size.width+4, photo.size.height+4);
			}else if(appDelegate.mainMenu == EYELASHES){
				if(photo == nil)
					photo = [UIImage imageNamed:@"eye2.png"];
				imageButton.frame = CGRectMake(thumbStartX+thumb_width+5, thumbStartY-20, photo.size.width+4, photo.size.height+4);
			}
			
			UIImage* photo2 = [photo stretchableImageWithLeftCapWidth:4 topCapHeight:4];
			[imageButton setImage:photo2 forState:UIControlStateNormal];
						
			imageButton.adjustsImageWhenHighlighted = NO;
			[imageButton addTarget:self action:@selector(thumbTapped:event:) forControlEvents:UIControlEventTouchUpInside];
			imageButton.tag = 500;			
			
			[photoContainer addSubview:imageButton];
			[photoContainer bringSubviewToFront:imageButton];		
	}
	
	//---------------------------------------------------------------------------
	if(t == 2){
			UIButton *imageButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
			if(appDelegate.mainMenu == LINGERIE||
			   appDelegate.mainMenu == CATEGORIES){
				imageButton2.frame = CGRectMake(thumbStartX, thumbStartY, photo.size.width+4, photo.size.height+4);
			}else if(appDelegate.mainMenu == EYELASHES){
				if(photo == nil)
					photo = [UIImage imageNamed:@"eye.png"];
				imageButton2.frame = CGRectMake(thumbStartX, thumbStartY-20, photo.size.width+4, photo.size.height+4);
			}
			
		    UIImage* photo2 = [photo stretchableImageWithLeftCapWidth:4 topCapHeight:4];
			[imageButton2 setImage:photo2 forState:UIControlStateNormal];		    
			
			imageButton2.adjustsImageWhenHighlighted = NO;
			[imageButton2 addTarget:self action:@selector(thumbTapped:event:) forControlEvents:UIControlEventTouchUpInside];
			imageButton2.tag = 501;				
				
			[photoContainer addSubview:imageButton2];   
			[photoContainer bringSubviewToFront:imageButton2];		
	}
	
	UIView *frontButtonView = [self findSubViewByTag:photoContainer Tag:500];
	UIView *backButtonView = [self findSubViewByTag:photoContainer Tag:501];
	if(isBlack){
		if(frontButtonView != nil){				
			frontButtonView.backgroundColor = RGB(96, 189, 242);
		}
		if(backButtonView != nil){			
			backButtonView.backgroundColor = [UIColor clearColor];
		}		
	}else{
		if(frontButtonView != nil){				
			frontButtonView.backgroundColor = [UIColor clearColor];
		}
		if(backButtonView != nil){				
			backButtonView.backgroundColor = RGB(96, 189, 242);
		}
	}
	
}

- (void)thumbTapped:(id)sender event:(id)event
{
	// only for big picture.
	if(controllerType != SLIDESHOW_BIGPICTURE){
		return;
	}
	
	[controller resetPageOrder];
	
	NSInteger tag = ((UIButton *)sender).tag;
	thumbIndex = tag;
	
	BACIAppDelegate* appDelegate = 
	    (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
	int startId = [appDelegate getCurrentSeriesStartId:0];	
	
	int idx = currentIndex+startId;
	if(controllerType == SLIDESHOW_BIGPICTURE){
	   idx += [controller getCurrentOffset];
	}else{
	   idx += [controller getCurrentOffset]*3;
	}
	if(idx <= 0)
	    idx = 1;
	
	isBlack = FALSE;
	
	NSString *location = [NSString stringWithFormat:@"%@/368x436/%03d_F.jpg",@"Medium",idx];
	if (tag == 500){
		 isBlack = TRUE;	    
		location = [NSString stringWithFormat:@"%@/368x436/%03d_B.jpg",@"Medium",idx];
		
	}
	
	UIImage *photo = [appDelegate getLocalImageAtIndex:currentIndex Location:location];
	[self setPhoto:photo atIndex:currentIndex Location:location];
			
	 if (tag == 500)
	 {		 
		 [UIView beginAnimations:nil context:nil];
		 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		 [UIView setAnimationDuration:1.0];
		 [UIView setAnimationDelegate:nil];
		 UIView *photoContainer = [photoContainers objectAtIndex:currentIndex];
		 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:photoContainer cache:YES];
		 
	     [self showPhotoAtIndex:currentIndex];
		 
		 [UIView commitAnimations];		
	 
	 }
	 else if (tag == 501)
	 {
		 [UIView beginAnimations:nil context:nil];
		 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		 [UIView setAnimationDuration:1.0];
		 [UIView setAnimationDelegate:nil];
		 UIView *photoContainer = [photoContainers objectAtIndex:currentIndex];
		 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:photoContainer cache:YES];
		 [self showPhotoAtIndex:currentIndex];		 
		 [UIView commitAnimations];		
	 }else{
		 BACIAppDelegate* appDelegate = (BACIAppDelegate*)[[UIApplication sharedApplication] delegate];
		 NSString* filename = [appDelegate getMovieNamebyIndex:idx];		 		 
		 [controller playVideo:filename];		 
	 }	
	
}


- (void)showPhotoAtIndex:(int)index
{
	//CGRect bounds = [[UIScreen mainScreen] bounds];
	//float screenWidth =  bounds.size.width;
	//float screenHeight =  bounds.size.height;	
	int screenWidth =  1024; 
	int screenHeight =  768-44*2-20;
	
	if(controllerType != SLIDESHOW_BIGPICTURE){		
		//screenWidth = (screenWidth + PHOTO_SPACING)/3; 
		screenWidth = 341;//screenWidth/3; 
	}
	
	if(index > (numberOfPhoto-1)){		
		return;
	}
	
	currentIndex = index;
	
    [mainLayout scrollRectToVisible:
     CGRectMake((screenWidth + PHOTO_SPACING) * index, 44,
				screenWidth + PHOTO_SPACING, screenHeight)
     animated:NO];		
	
	
}

- (UIView *)loadingIndicatorView
{
	CGRect bounds = [[UIScreen mainScreen] bounds];
	float screenWidth =  bounds.size.width;
	float screenHeight =  bounds.size.height;
	screenWidth =  1024; 
	screenHeight =  768;
	
	screenHeight -= FIX_BARS_HEIGHT;
	
    UIActivityIndicatorView *spinner
        = [[UIActivityIndicatorView alloc] initWithFrame:
           CGRectMake((screenWidth - SPINNER_WIDTH) / 2,
                      (screenHeight - SPINNER_WIDTH) / 2,
                      SPINNER_WIDTH, SPINNER_WIDTH)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [spinner startAnimating];
    return [spinner autorelease];	
	
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//CGRect bounds = [[UIScreen mainScreen] bounds];
	//int screenWidth =  bounds.size.width;
	int screenWidth =  1024; 
    	
	if(controllerType != SLIDESHOW_BIGPICTURE){		
		//screenWidth = (screenWidth + PHOTO_SPACING)/3; 
		screenWidth = 341;//screenWidth/3; 
	}
	
    int x = mainLayout.bounds.origin.x;
			
    //fixed array beyond.
	int index = x / (screenWidth + PHOTO_SPACING);
	if(x % (screenWidth + PHOTO_SPACING)){
		    index++;
	}
		
    [controller scrolledToIndex:index];
	currentIndex = index; 
			
	
}

- (UIView *)findSubViewByTag:(UIView *)parent Tag:(int)t{
	if(parent == nil)
		return nil;
	int count = [parent.subviews count];
	for(int i = 0; i< count; i++){
		UIView *view = [parent.subviews objectAtIndex:i];
		if(view.tag == t){
			return view;
		}
	}
	return nil;		   
}
		
-(UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{		
   
}

@end
