//
//  TableViewController.m
//  TableView
//
//  Created by Henry Yu on 10/21/09.
//  Copyright Sevenuc.com 2009. All rights reserved.//

#import "TableViewController.h"


@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        names = [[NSArray alloc] initWithObjects:@"Paul", @"Evan", @"Troy", @"Adam",@"Kayvon", @"Joe", nil];
    }
    return self;
}

- (void)dealloc
{
    [names release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [names count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:nil] autorelease];
    
    cell.text = [names objectAtIndex:indexPath.row];
    
    return cell;
}

@end
