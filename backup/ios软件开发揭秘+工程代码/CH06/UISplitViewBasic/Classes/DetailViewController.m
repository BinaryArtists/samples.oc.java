//
//  DetailViewController.m
//  UISplitViewBasic
//
//  Created by Henry Yu on 5/18/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "AnimalViewController.h"
#import "TouchableView.h"
#import "HLayoutView.h"


@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

#define PHOTO_SPACING 10
#define SPINNER_WIDTH 10
#define IMAGE_WIDTH   120
#define IMAGE_HEIGHT  100

@implementation DetailViewController

@synthesize toolbar, popoverController, detailItem;
@synthesize currentCategory;

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}


- (void)configureView {
    // Update the user interface for the detail item.
    //detailDescriptionLabel.text = [detailItem description];   
}


#pragma mark -
#pragma mark Split view support


- (void)splitViewController:(UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController:(UIPopoverController*)pc
{
  
  [barButtonItem setTitle:@"Root List"];
  [[self navigationItem] setLeftBarButtonItem:barButtonItem];
  [self setPopoverController:pc];
}


- (void)splitViewController:(UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
  [[self navigationItem] setLeftBarButtonItem:nil];
  [self setPopoverController:nil];
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
		||(interfaceOrientation == UIInterfaceOrientationLandscapeRight)){
		return YES;
	}else{
		return NO;
	}
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setTitle:@"Animails"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];	
		
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

- (void)dealloc {
	[photoContainers release];
    [mainLayout release];
	
    [popoverController release];
    [toolbar release];
    
    [detailItem release];
    [super dealloc];
}

#pragma mark -
#pragma mark Images management


- (NSString *)getImagePrefix:(int)category{
	NSString *name;	
	if(category == 0){
		name = @"animal";
	}else if(category == 1){		
		name = @"bird";		
	}else{
		name = @"fish";
	}
	return name;
}


- (void)goDeatilScreen:(NSDictionary *)userInfo{
	int idx = [[userInfo objectForKey:@"index"] intValue];
		
	// Create and push new view controller here
	NSString *prefix = [self getImagePrefix:currentCategory];	
	AnimalViewController *controller = [[AnimalViewController alloc] init];
	controller.imageName = [NSString stringWithFormat:@"%@%d.jpg",prefix, idx+1];
	[[self navigationController] pushViewController:controller animated:YES];
	[controller release], controller = nil;
	
}


- (void)setNumberOfPhotos:(int)n
{
    [mainLayout removeFromSuperview];
    [mainLayout release];
	numberOfPhoto = n;
	
	//CGRect bounds = [[UIScreen mainScreen] bounds];
	CGRect bounds = [self.view bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	
    mainLayout = [[HLayoutView alloc] initWithFrame:
                  CGRectMake(-PHOTO_SPACING/2, 10, 
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
			
    [self.view addSubview:mainLayout];
	[self.view bringSubviewToFront:mainLayout];
	
    [photoContainers release];
    photoContainers = [[NSMutableArray alloc] initWithCapacity:n];
	
    for (int i = 0; i < n; ++i)
    {
		NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  [NSNumber numberWithInt:i] forKey:@"index"];
		UIView *container;
		container = [[TouchableView alloc] initWithFrame:
						 CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT)
													  target:self userInfo:userInfo];
			((TouchableView*)container).touchesEndedSelector = @selector(goDeatilScreen:);
			container.backgroundColor = [UIColor clearColor];
			
        [mainLayout addSubview:container];
        [container release];			
		
        [photoContainers addObject:container];
    }
    // force layout 
    [mainLayout layoutSubviews];
}

- (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;	
}

- (void)setPhoto:(UIImage *)photo atIndex:(int)index
{
	
	float screenWidth =  IMAGE_WIDTH;    
	float screenHeight =  IMAGE_HEIGHT;  
		
	//remove subviews 	
    UIView *photoContainer = [photoContainers objectAtIndex:index];
 
    float width = photo.size.width;
    float height = photo.size.height;
	
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
					
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 0, width, height)];
	
	CGSize iSize  = CGSizeMake(110,90);
	imageView.image = [self resizeImage:photo scaledToSize:iSize];			
	imageView.backgroundColor = [UIColor clearColor];
    [photoContainer addSubview:imageView];
	
	[imageView release];
	
}



- (void)loadImages{
	int n = 4;
	[self setNumberOfPhotos:4];
	
	NSString *prefix = [self getImagePrefix:self.currentCategory];
	for(int i = 0; i < n; i++){
		int j = i + 1;
		NSString *name = [NSString stringWithFormat:@"%@%d.jpg", prefix, j];
		UIImage *image = [UIImage imageNamed:name];
		[self setPhoto:image atIndex:i];
	}
	
}

@end
