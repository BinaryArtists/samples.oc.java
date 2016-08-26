//
//  WordListTableViewController.m
//  Vocabulary
//
//  Created by Henry Yu on 10/21/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "WordListTableViewController.h"
#import "DefinitionViewController.h"

@interface WordListTableViewController()
@property (retain) NSMutableDictionary *words;
@property (retain) NSArray *sections;
@end

@implementation WordListTableViewController

@synthesize words, sections;

- (NSMutableDictionary *)words
{
	if (!words) {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *filePath = [bundle  pathForResource:@"words" ofType:@"txt"];		
		words = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];		
	}
	return words;
}

- (NSArray *)sections
{
	if (!sections) {
		sections = [[[self.words allKeys] sortedArrayUsingSelector:@selector(compare:)] retain];
	}
	return sections;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Vocabulary Sorting";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *wordsInSection = [self.words objectForKey:[self.sections objectAtIndex:section]];
	return wordsInSection.count;
}

- (NSString *)wordAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *wordsInSection = [self.words objectForKey:[self.sections objectAtIndex:indexPath.section]];
	return [wordsInSection objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WordListTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [self wordAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSString *section = [self.sections objectAtIndex:indexPath.section];
		NSMutableArray *wordsInSection = [[self.words objectForKey:section] mutableCopy];
		[wordsInSection removeObjectAtIndex:indexPath.row];
		[self.words setObject:wordsInSection forKey:section];
		[wordsInSection release];
		// Delete the row from the table view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [self.sections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return self.sections;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	DefinitionViewController *dvc = [[DefinitionViewController alloc] init];
	dvc.word = [self wordAtIndexPath:indexPath];
	[self.navigationController pushViewController:dvc animated:YES];
	[dvc release];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[words release];
	[sections release];
    [super dealloc];
}

@end

