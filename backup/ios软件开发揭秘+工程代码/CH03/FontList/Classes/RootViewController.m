//
//  RootViewController.m
//  FontList
//
//  Created by Henry Yu on 11/17/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import "RootViewController.h"
#import "FontListAppDelegate.h"


@implementation RootViewController

@synthesize fontNames;

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.title = @"Font List";	
    self.fontNames = [NSMutableArray array];
    NSArray *fontFamilyNames = [UIFont familyNames];
    for (NSString *familyName in fontFamilyNames) {
        NSLog(@"familyName = %@", familyName);
        NSArray *names = [UIFont fontNamesForFamilyName:familyName];
        NSLog(@"FontNames = %@", fontNames);
        [self.fontNames addObjectsFromArray:names];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [fontNames count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *name = [self.fontNames objectAtIndex:indexPath.row];
    		
	cell.textLabel.text = name; 
	cell.textLabel.font = [UIFont fontWithName:name size:14];
	NSLog(@"%@",name);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Navigation logic -- create and push a new view controller
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end

