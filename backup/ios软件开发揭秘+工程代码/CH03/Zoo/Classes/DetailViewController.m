    //
//  DetailViewController.m
//  Zoo
//
//  Created by Henry Yu on 10-11-09.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "Animal.h"

@implementation DetailViewController

- (void)initAnimal:(Animal *)a{
	animal = a;
	[animal retain];
	if(imageView != nil){
		[imageView release];		
	}
	imageView = nil;
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	UIImage *image = [UIImage imageWithData: animal.image]; 
	imageView = [[UIImageView alloc] initWithFrame:CGRectMake(
							  (screenWidth-image.size.width)/2,
							  (screenHeight-image.size.height)/2, 
							  image.size.width, 
							  image.size.height) ];
	[imageView setImage:image];	
	//[self.view addSubview:imageView];
	//[imageView release];
				
	
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	//CGRect frame = [[UIScreen mainScreen] applicationFrame];
	CGRect frame = self.view.bounds;
	UIView *view = [[UIView alloc] initWithFrame: frame];
	self.navigationItem.title = @"Animal Detail";	
	self.view = view;	
	[view release];
	
	mainView = [[UIView alloc] initWithFrame: self.view.bounds];	
	[self.view addSubview:mainView];
	
	if(animal != nil){
		CGRect selfFrame = self.view.frame;
		int screenY =  selfFrame.origin.y;
				
	    UILabel *myLabel = [[UILabel alloc] 
							initWithFrame:CGRectMake((frame.size.width-160)/2, screenY+44, 160,40)];
	    myLabel.text = animal.name;	
		myLabel.font = [UIFont fontWithName:@"Arial" size: 24.0];
	    [self.view addSubview:myLabel];
		[myLabel release];
	}
	
	if(imageView != nil){		
		[self.view addSubview:imageView];
		[imageView release];
	}
		
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad {
//    [super viewDidLoad];
//}


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


@end
