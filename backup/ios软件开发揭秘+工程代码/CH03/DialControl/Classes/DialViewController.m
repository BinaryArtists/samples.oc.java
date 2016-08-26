//
//  DialViewController.m
//  DialControl
//
//  Created by Henry Yu on 10-11-27.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "DialViewController.h"

@interface DialViewController()
float lastValue;
@end


@implementation DialViewController
@synthesize records;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)initDialView{
	
	dialView = [[UIDialView alloc] init];
	dialView.delegate = self;
			
	//position and size
	dialView.transform = CGAffineTransformMakeScale(.55,.55);		
	dialView.center = self.view.center;
		
	//add to view
	dialView.opaque = NO;
	[self.view addSubview:dialView];	
	[self.view bringSubviewToFront:dialView];	
	
}

- (void)dialValue:(int)tag Value:(float)value
{
	//[scanner tunning:value];
	if (lastValue == 0.00) {
		lastValue = lastValue;
	}
	
	lastValue = value;		
	
    float v = value/100;
	if ((int)v < 0) {
		v = 0.0; 
	}else if((int)value > 100) {
		v = 1.0;
	}else{		
	}
	
	NSString *str = [NSString stringWithFormat:@"%.1f",v*100];
    [myLabel performSelector:@selector(setText:) withObject:str];
	NSLog(@" value:%.1f, v:%.1f",value, v);	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
	self.navigationItem.title = @"Dial Control",
	[self initDialView];
	
	myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60,12)];
	myLabel.text = @"0.0";	
	dialView.center = self.view.center;
	//[myLabel sizeToFit];
	myLabel.center = CGPointMake(dialView.center.x, dialView.center.y+dialView.bounds.size.height/2);
	myLabel.backgroundColor = [UIColor clearColor];
	myLabel.textColor = [UIColor whiteColor];
	myLabel.font = [UIFont fontWithName:@"Arial" size: 16];
	[self.view addSubview:myLabel];
	
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
