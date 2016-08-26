//
// File: SearchViewController.m
// Abstract: Search table view controller for the application.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation SearchViewController

@synthesize delegate, dataArray;
@synthesize disableViewOverlay;
@synthesize searchArray,myTableView;

// Prepare the Table View
- (void)loadView
{
	[super loadView];	
	searching = NO;
	NSArray *countriesToLiveInArray;
	//Initialize the array.
	dataArray = [[NSMutableArray alloc] init];

	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	countriesToLiveInArray = appDelegate.searchList;

	NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
	NSArray *countriesLivedInArray = [[NSMutableArray alloc] init];
	NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
	
	[dataArray addObject:countriesToLiveInDict];
	[dataArray addObject:countriesLivedInDict];
	
	//NSLog(@"dataArray:%@",dataArray);
	
	//Initialize the copy array.
	searchArray = [[NSMutableArray alloc] init];
	
	//-------------------------------------------------------------------------------------
	search = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 44.0f)];
	search.delegate = self;
	search.placeholder = @"keyword match text";
	search.autocorrectionType = UITextAutocorrectionTypeNo;
	search.autocapitalizationType = UITextAutocapitalizationTypeNone;	
	self.navigationItem.titleView = search;		
	[search release];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
								   initWithTitle:NSLocalizedString(@"Back", @"")
								   style:UIBarButtonItemStylePlain
								   target:self
								   action:@selector(back)];
	self.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
	
	// "Search" is the wrong key usage here. Replacing it with "Done"
	UITextField *searchField = [[search subviews] lastObject];
	[searchField setReturnKeyType:UIReturnKeyDone]; 	
	
}

- (void)viewDidLoad {
    [super viewDidLoad];  
		
	searching = NO;
	letUserSelectRow = YES;	
     
	self.disableViewOverlay = [[UIView alloc]
							   initWithFrame:CGRectMake(0.0f,0.0f,320.0f,416.0f)];
    self.disableViewOverlay.backgroundColor=[UIColor blackColor];
    self.disableViewOverlay.alpha = 0;	
	
	[myTableView reloadData];	
		
}

- (void)viewDidUnload{
	self.searchArray = nil;
	self.dataArray = nil;
	disableViewOverlay = nil;
}


- (void)viewDidAppear:(BOOL)animated {
    [search becomeFirstResponder];
    [super viewDidAppear:animated];	
	
	// no mask view.
	[self searchBarCancelButtonClicked:nil];
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];	
	// Release any cached data, images, etc that aren't in use.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	if (searching)
		return 1;
	else
		return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (searching){
		return [searchArray count];
	}else {		
		//Number of rows it should expect should be based on the section
		NSDictionary *dictionary = [dataArray objectAtIndex:section];
		NSArray *array = [dictionary objectForKey:@"Countries"];
		return [array count];
	}
	
}

- (NSIndexPath *)tableView :(UITableView *)theTableView 
             willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
		return @"";		
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"SearchCell";
	// Create a cell if one is not already available
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		
	NSString *cellValue = nil;	
	
	NSInteger n = indexPath.row;
	if(n > [searchArray count]){
		//First get the dictionary object
		NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
		NSArray *array = [dictionary objectForKey:@"Countries"];
		cellValue = [array objectAtIndex:indexPath.row];
	}else{	
		if(searching){
			cellValue = [searchArray objectAtIndex:indexPath.row];
		}else {
			//First get the dictionary object
			NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
			NSArray *array = [dictionary objectForKey:@"Countries"];
			cellValue = [array objectAtIndex:indexPath.row];
		}
	}
	
	NSArray *crayon = [cellValue componentsSeparatedByString:@"#"];
	cell.textLabel.text = [crayon objectAtIndex:1];
	return cell;	
	
}


// Remove the current table row selection
- (void) deselect{	
	[self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

- (void)back{
	[self dismissSelfView:@"" Back:YES];
}

- (void)dismissSelfView:(NSString*)item Back:(BOOL)back{
	
	if(!back){
		if ([self.delegate respondsToSelector:@selector(SearchResultString:)]){
			[self.delegate SearchResultString:item];	
		}
	}
	
	//[self.myTableView removeFromSuperview];	
	//[search removeFromSuperview];
	//[[self.delegate NavigationController] popViewControllerAnimated:YES];	
	
	[self.navigationController popViewControllerAnimated:YES];
	//[[self.delegate NavigationController] popViewControllerAnimated:YES];
	
}

// Respond to user selection by coloring the navigation bar
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
			
	NSString *selectedCountry = nil;	
	if(searching)
		selectedCountry = [searchArray objectAtIndex:newIndexPath.row];
	else {		
		NSDictionary *dictionary = [dataArray objectAtIndex:newIndexPath.section];
		NSArray *array = [dictionary objectForKey:@"Countries"];
		selectedCountry = [array objectAtIndex:newIndexPath.row];
	}
	
	[self dismissSelfView:selectedCountry Back:NO];		
	
}


- (void) searchTableView {
	
	NSString *searchText = search.text;
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	
	for (NSDictionary *dictionary in dataArray)
	{
		NSArray *array = [dictionary objectForKey:@"Countries"];
		[tempArray addObjectsFromArray:array];
	}
	
	for (NSString *sTemp in tempArray)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[searchArray addObject:sTemp];
	}
	
	[tempArray release];
	tempArray = nil;
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{	
		
	// only show the status bar's cancel button while in edit mode	
	search.showsCancelButton = YES;	
	search.autocorrectionType = UITextAutocorrectionTypeNo;	
				
	searching = YES;
	letUserSelectRow = NO;	
	self.myTableView.scrollEnabled = NO;	
		
	//Add the overlay view.
	[self searchBar:searchBar activate:YES];
			
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{	
	search.showsCancelButton = NO;	
}

// When the search text changes, update the array
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	//Remove all objects first.
	[searchArray removeAllObjects];
	
	if([searchText length] > 0) {			
		[self searchBar:searchBar activate:NO];		
		searching = YES;
		letUserSelectRow = YES;
		self.myTableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {	
		[self searchBar:searchBar activate:YES];

		searching = NO;
		letUserSelectRow = NO;
		self.myTableView.scrollEnabled = NO;
	}	
		
	[self.myTableView reloadData];

	
}

// When the search button (i.e. "Done") is clicked, hide the keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[search resignFirstResponder];
	[self searchTableView];	
	[self cancel];		 	
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	// if a valid search was entered but the user wanted to cancel, 
	// bring back the main list content
	[searchArray removeAllObjects];		
	search.text = @"";		
	
	[self cancel];	
    [self searchBar:search activate:NO];	
}


- (void)searchBar:(UISearchBar *)searchBar activate:(BOOL) active{	
    self.myTableView.allowsSelection = !active;
    self.myTableView.scrollEnabled = !active;
    if (!active) {
        [disableViewOverlay removeFromSuperview];        
    } else {
        self.disableViewOverlay.alpha = 0;
        [self.view addSubview:self.disableViewOverlay];
		
        [UIView beginAnimations:@"FadeIn" context:nil];
        [UIView setAnimationDuration:0.5];
        self.disableViewOverlay.alpha = 0.6;
        [UIView commitAnimations];	
  
        NSIndexPath *selected = [self.myTableView indexPathForSelectedRow];
        if (selected) {
            [self.myTableView deselectRowAtIndexPath:selected animated:NO];
        }
    }
    
}


- (void)cancel{
		
	search.text = @"";
	[search resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.myTableView.scrollEnabled = YES;	
	
	[disableViewOverlay removeFromSuperview];
	[disableViewOverlay release];
	disableViewOverlay = nil;
	
	[self.myTableView reloadData];		
}


// Clean up
-(void) dealloc{
	[dataArray release];
	[searchArray release];	
  
	[super dealloc];
}

//
- (void)setNavigatinBarStyle:(NSInteger)style{
    // Change the navigation bar style, also make the status bar match with it
	switch (style)	{
		case STATUS_BAR_STYLE_DEFAULT:{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
			search.barStyle = UIBarStyleDefault;
			break;
		}
		case STATUS_BAR_STYLE_BLACKOQAUE:{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
			search.barStyle = UIBarStyleBlackOpaque;
			break;
		}
		case STATUS_BAR_STYLE_BLACKTRANSLUCENT:	{
			[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackTranslucent;
			search.barStyle = UIBarStyleBlackTranslucent;
			break;
		}
	}
}


@end



