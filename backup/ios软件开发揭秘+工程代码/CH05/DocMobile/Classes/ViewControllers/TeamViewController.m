//
//  TeamViewController.m
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "TeamViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "DocListViewController.h"

@implementation TeamViewController

@synthesize records;


- (void)viewDidLoad {
	self.title = @"Please select a team";
		
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    records = [[appDelegate getTeams] copy]; 
	
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];	
}


- (void)dealloc {
    [super dealloc];	
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [self.records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AttachmentsCell= @"TeamsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: 
                             AttachmentsCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier: AttachmentsCell] autorelease];
    }
	
	// Configure the cell
    NSUInteger row = [indexPath row];

	NSDictionary *recordDict = [[records objectAtIndex:row] objectForKey:@"Team"];
	NSDictionary *Team = [recordDict objectForKey:@"TeamName"];
	NSString *title = [Team objectForKey:@"value"];	    
  
    cell.textLabel.text = title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView 
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
	
	NSUInteger row = [indexPath row];

	NSDictionary *recordDict = [[records objectAtIndex:row] objectForKey:@"Team"];
	NSDictionary *Team = [recordDict objectForKey:@"IDTeam"];
	NSDictionary *TeamName = [recordDict objectForKey:@"TeamName"];
	NSString *teamId = [Team objectForKey:@"value"];
	NSString *teamName = [TeamName objectForKey:@"value"];
	
	NSLog(@"teamId = %@",teamId);
	NSLog(@"teamName = %@",teamName);
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	[appDelegate setCurrentView:@"MyTeamDocumentView"];
	DocListViewController *controller = [[DocListViewController alloc] initWithNibName:@"DocListViewController" bundle:nil];
    [controller setTeamId:[teamId intValue]];
	[controller setTeamName:teamName];
	controller.title = teamName;

	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	[self.navigationController pushViewController:controller animated:YES];
	
	
	
}


@end
