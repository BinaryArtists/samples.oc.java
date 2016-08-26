//
//  RootViewController.m
//  SQLite
//
//  Created by Henry Yu on 11/1/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import "RootViewController.h"
#import "Coffee.h";
#import "AddViewController.h"
#import "DetailViewController.h"

@implementation RootViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appDelegate.coffeeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	//Get the object from the array.
	Coffee *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
	
	//Set the coffename.
	cell.textLabel.text = coffeeObj.coffeeName;
	
	//Set the accessory type.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Set up the cell
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic -- create and push a new view controller
	
	if(dvController == nil) 
		dvController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	
	Coffee *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
	
	//Get the detail view data if it does not exists.
	//We only load the data we initially want and keep on loading as we need.
	[coffeeObj hydrateDetailViewData];
	
	dvController.coffeeObj = coffeeObj;
	
	[self.navigationController pushViewController:dvController animated:YES];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
											 target:self action:@selector(add_Clicked:)];
	
	appDelegate = (SQLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	self.title = @"Coffee List";
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		
		//Get the object to delete from the array.
		Coffee *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
		[appDelegate removeCoffee:coffeeObj];
		
		//Delete the object from the table.
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
	
	//Do not let the user add if the app is in edit mode.
	if(editing)
		self.navigationItem.leftBarButtonItem.enabled = NO;
	else
		self.navigationItem.leftBarButtonItem.enabled = YES;
}	

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) add_Clicked:(id)sender {
	
	if(avController == nil)
		avController = [[AddViewController alloc] initWithNibName:@"AddView" bundle:nil];
	
	if(addNavigationController == nil)
		addNavigationController = [[UINavigationController alloc] initWithRootViewController:avController];
	
	[self.navigationController presentModalViewController:addNavigationController animated:YES];
}


- (void)dealloc {
	[dvController release];
	[addNavigationController release];
	[avController release];
    [super dealloc];
}


@end

