//
//  RootViewController.m
//  Zoo
//
//  Created by Henry Yu on 10-11-09.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "RootViewController.h"
#import "ListViewController.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if(!categories){
		categories = [NSMutableArray arrayWithObjects:@"Animal",@"Bird",@"Fish",nil];
		
	}
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

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:CellIdentifier] autorelease];
    }
	int row = indexPath.row;
	
	if(row == 0){
		cell.imageView.image = [UIImage imageNamed:@"a.jpg"];
	}else if(row == 1){
		cell.imageView.image = [UIImage imageNamed:@"b.jpg"];;
	}else{
		cell.imageView.image = [UIImage imageNamed:@"f.jpg"];
	}	
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text =  [categories objectAtIndex:row];
 	cell.detailTextLabel.text = [categories objectAtIndex:row];
	cell.detailTextLabel.numberOfLines = 2;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
  //   int row = indexPath.row;
	
	//CGRect bounds = self.view.bounds;
	//CGRect bounds = [[UIScreen mainScreen] bounds];
	//int screenWidth =  bounds.size.width;
	//int screenHeight =  bounds.size.height;
			
     ListViewController *detailViewController = [[ListViewController alloc] init];
	 detailViewController.iCurrentCategory = indexPath.row + 1;
	 detailViewController.fetchedResultsController = nil;
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
  
    [super dealloc];
}

@end

