//
//  RootViewController.m
//  HappyPinting
//
//  Created by Henry Yu on 12/7/10.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#define kTagCoverflow 1000

@implementation RootViewController;

@synthesize iCurrentCategory;
@synthesize iCurrentSelection;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
//	loadImagesOperationQueue = [[NSOperationQueue alloc] init];
	
	imageArray = [[NSMutableArray alloc] init];
	//ZooAppDelegate *appDelegate = (ZooAppDelegate*)[[UIApplication sharedApplication] delegate];
	//self.managedObjectContext = appDelegate.managedObjectContext;
				
	//if (appDelegate.isShouldInitData){
		[self initAnimals];
	//	appDelegate.isShouldInitData = NO;
	//}
	
	//paintingViewController = nil;
	
	//never care about the frame property if the view will be placed in a NavigationController
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.view setBackgroundColor:[UIColor clearColor]];
	self.navigationItem.title = @"Tiger";
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Tiger" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
		
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"latest movie view did loaded,superview is:%@",self.view.superview);
}*/


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	AFOpenFlowView *coverFlowView = (AFOpenFlowView*)[self.view viewWithTag:kTagCoverflow];
	if(nil == coverFlowView)
		[self refreshCoverFlow];
	//button.hidden = NO;

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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	//[loadImagesOperationQueue release];
//	[self.movies release];
	//[self.locationMovies release];
    [super dealloc];
}

- (void)showDetail:(id)sender{
	 
}

- (void)showAllCinemas:(id)sender{
	//[DataEnvironment sharedDataEnvironment].useDefaultCinemaBinding = NO;
	//[self updateLocationMoviesByEnvironmentLocationId];
}

- (NSInteger) numberOfAnimals{
    //id <NSFetchedResultsSectionInfo> sectionInfo = 
	//[[self.fetchedResultsController sections] objectAtIndex:0];
    //return [sectionInfo numberOfObjects];
	return [imageArray count];
}

- (void)refreshCoverFlow{
		
	CGRect bounds = [[UIScreen mainScreen] bounds];
	AFOpenFlowView *coverFlowView = (AFOpenFlowView*)[self.view viewWithTag:kTagCoverflow];
	if(coverFlowView != nil)
	   [coverFlowView removeFromSuperview];	
	coverFlowView = [[AFOpenFlowView alloc] initWithFrame:CGRectMake(0, -30, bounds.size.width, COVERFLOWHEIGHT)];
	coverFlowView.dataSource = self;
	coverFlowView.viewDelegate = self;
	coverFlowView.defaultImage = [self defaultImage];
	coverFlowView.tag = kTagCoverflow;
	[self.view addSubview:coverFlowView];
	
	//set default selected image
	NSInteger idxSelected = -1;
	NSInteger count = [self numberOfAnimals];
	
	NSLog(@"count:%d",count);
	
	if ( count != 0) {
		[coverFlowView setNumberOfImages:count];
		
		if (idxSelected != -1) {
			[coverFlowView setSelectedCover:idxSelected];
		}else {
			if (count > 3) {
				[coverFlowView setSelectedCover:2];
			}else {
				[coverFlowView setSelectedCover:0];
			}

		}
		[coverFlowView centerOnSelectedCover:NO];
	}else {
		[coverFlowView setNumberOfImages:0];
	}
	if (idxSelected != -1) {
		[self openFlowView:coverFlowView selectionDidChange:idxSelected];
	}else{
		if (count > 3) {
			[self openFlowView:coverFlowView selectionDidChange:2];
		}else {
			[self openFlowView:coverFlowView selectionDidChange:0];
		}

	}
	
	//NSInteger count = [self numberOfAnimals];
	if (count == 0) {
		coverFlowView.alpha = 0;
		[self setDataAvailable:NO];
	}else {
		[self setDataAvailable:YES];
		coverFlowView.alpha = 0;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		coverFlowView.alpha = 1;
		[UIView commitAnimations];
	}
	
	[coverFlowView release];
	
}

- (void) setDataAvailable:(BOOL)available{
//	CGRect bounds = [[UIScreen mainScreen] bounds];
		
}


#pragma mark -
#pragma mark Core Data management
- (void)initAnimals{
	int i = 0;	
	for(i = 1; i < 5; i++){
		NSString *name = [NSString stringWithFormat:@"wall_25%02d",i];
		NSString *image = [NSString stringWithFormat:@"wall_25%02d.png",i];		
		[self doAddAnimal:name Image:image];
	}
	
}

- (NSString *)getImagePath:(NSString *)imageName{
	NSString *homePath = [[NSBundle mainBundle] executablePath];
	NSArray *strings = [homePath componentsSeparatedByString: @"/"];
	NSString *executableName  = [strings objectAtIndex:[strings count]-1];	
	NSString *rawDirectory = [homePath substringToIndex:
							  [homePath length]-[executableName length]-1];
	NSString *baseDirectory = [rawDirectory stringByReplacingOccurrencesOfString:@" " 
																	  withString:@"%20"];
	NSString *imagePath = [NSString stringWithFormat:@"file://%@/images/%@",baseDirectory,imageName];	
    NSLog(@"imagePath: %@",imagePath);
	return imagePath;
}

-(UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize {
	
	UIGraphicsBeginImageContext( newSize );
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;	
}

- (BOOL)doAddAnimal:(NSString *)name Image:(NSString *)imageName{
	
	// Create a new instance of the entity managed by the fetched results controller.
    //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    //NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
	
//	NSURL *url = [NSURL URLWithString: [self getImagePath:imageName]];
//	NSData *imageData = [NSData dataWithContentsOfURL:url]; 	
//	UIImage *image = [UIImage imageWithData: imageData];
	UIImage *image = [UIImage imageNamed: imageName];
	if(image == nil) return FALSE;
	CGSize size  = CGSizeMake(179, 208);
	[imageArray addObject:[self resizeImage:image scaledToSize:size]];
	//[image release];
		
	return TRUE;
	
}


#pragma mark -
#pragma mark AFOpenFlowView Methods
- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index{

 UIImage *image =  [imageArray objectAtIndex:index];
	 [openFlowView setImage:image forIndex:index];
	 //[image release];
	 // NSLog(@"requestedImageCount: %d", requestedImageCount);

}

- (UIImage *)defaultImage{
	return [UIImage imageNamed:@"of_default.png"];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index{
	NSLog(@"selectionDidChange called!");
	NSInteger count = [self numberOfAnimals];
	if (count == 0) {
		return;
	}
	iCurrentSelection = index;
	//if(paintingViewController == nil){
	//	paintingViewController = [[PaintingViewController alloc] 
	//			  initWithNibName:@"PaintingViewController" bundle:nil];
    //}	
	
//	[self.navigationController pushViewController:paintingViewController animated:YES];
//	[paintingViewController release];
	
	
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView coverViewDoubleClick:(int)index{
	 NSLog(@"coverViewDoubleClick called!");
	 [self showPaintingViewController];
}

- (void)imageDidLoad:(NSArray *)arguments {
	UIImage *loadedImage = (UIImage *)[arguments objectAtIndex:0];
	NSNumber *imageIndex = (NSNumber *)[arguments objectAtIndex:1];
	
	// Only resize our images if they are coming from Flickr (samples are already scaled).
	// Resize the image on the main thread (UIKit is not thread safe).
	//if (interestingnessRequest)
	//loadedImage = [loadedImage rescaleImageToSize:COVERFLOWIMAGESIZE];
	AFOpenFlowView *coverFlowView = (AFOpenFlowView*)[self.view viewWithTag:kTagCoverflow];
	[coverFlowView setImage:loadedImage forIndex:[imageIndex intValue]];
}

//- (void)coverViewDoubleClick:(NSArray *)clickPoints{
- (void)showPaintingViewController	{
	//CGRect				bounds = [self bounds];
    //UITouch*	touch = [[event touchesForView:self] anyObject];
	if(iCurrentSelection == -1) return;
	/*
		if(paintingViewController == nil){
			NSLog(@"touchesEnded, paintingViewController == nil!");
			paintingViewController = [[PaintingViewController alloc] 
									  initWithNibName:@"PaintingViewController" bundle:nil];
		}
	   
	    NSString *imageName = [NSString stringWithFormat:@"image%02d",iCurrentSelection+1];
	    NSLog(@"showPaintingViewController,imageName:%@",imageName);
	    [paintingViewController updateImage:imageName];			
		[self.navigationController pushViewController:paintingViewController animated:YES];
	    //[paintingViewController release];	
	
	*/	
	
}


@end



