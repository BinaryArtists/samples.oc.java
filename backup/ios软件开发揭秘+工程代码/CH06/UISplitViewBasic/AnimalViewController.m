//
//  AnimalViewController.m
//  UISplitViewBasic
//
//  Created by Henry Yu on 5/18/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "AnimalViewController.h"


@implementation AnimalViewController

@synthesize  imageName;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setTitle:@"Animal Detail"];
	self.view.backgroundColor = [UIColor whiteColor];
	CGRect bounds = [self.view bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	UIImage *image = [UIImage imageNamed: imageName]; 
	int iImageY = (screenHeight-image.size.height)/2-image.size.height;
	if(iImageY < 0){
		iImageY = 20;
	}
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
							  (screenWidth-image.size.width)/2,
							  iImageY, image.size.width, image.size.height)];
	[imageView setImage:image];	
	[self.view addSubview:imageView];
	[imageView release];
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
	if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
		||(interfaceOrientation == UIInterfaceOrientationLandscapeRight)){
		return YES;
	}else{
		return NO;
	}
}


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


@end
