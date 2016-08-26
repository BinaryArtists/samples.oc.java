//
//  MainViewController.m
//  MultiLineText
//
//  Created by Henry Yu on 3/29/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import "MainViewController.h"
#import "MultiLineTextViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation MainViewController

@synthesize  commentField;

- (UINavigationController *)navController{
	return self.navigationController;
}

- (IBAction)editComment:(id)sender{
	MultiLineTextViewController *controller = 
	[[MultiLineTextViewController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.delegate = self;	
	controller.string = @"comment text";
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release]; 
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)takeNewString:(NSString *)newValue{
	commentField.text = newValue;	
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
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"MultiLine Text Input";
	commentField.text = @"1, Rocky\n(1976 1979 1982 1985 1990 2006) \n\n 2, The Shawshank Redemption(1994)\n\n  3, Cast Away(2000)\n\n";
	
	[self.commentField setEditable: NO];
	self.commentField.layer.borderWidth = 1;	
	self.commentField.layer.cornerRadius = 8; //This is for achieving the rounded corner.	
	self.commentField.layer.borderColor = [[UIColor grayColor] CGColor];
	self.commentField.scrollEnabled = YES;
	self.commentField.textAlignment = UITextAlignmentLeft;
	
	//self.commentField.textColor = [UIColor colorWithWhite:1 alpha:1];
	//self.commentField.backgroundColor = [UIColor clearColor];	
	//self.commentField.font = [UIFont systemFontOfSize:13];
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


@end
