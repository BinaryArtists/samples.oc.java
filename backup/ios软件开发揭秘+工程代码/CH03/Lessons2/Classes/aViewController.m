//
//  aViewController.m
//  TabBar plus NavBar
//
//  Created by Pierre Addoum on 11/27/09.
//  Copyright 2009. All rights reserved.
//

#import "aViewController.h"

#define MyTableHeaderHeight 140
#define MyTableHeaderHeight2 60

#define IS_IPHONE_VERSION   1

@implementation aViewController

//@synthesize myTableView;

-(void)doLoadVeiw{
	[super loadView];
	NSLog(@"loadVeiw....");
	
	if(background == nil){
		 background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
		 //self.view.backgroundColor = background;
		 NSLog(@"background:%d",background);		
		 CGRect windowBounds = [[UIScreen mainScreen] bounds];
		 int screenWidth =  windowBounds.size.width;
		 int screenHeight =  windowBounds.size.height;
		 UIView *backgroundView = [[[UIView alloc] initWithFrame:
		 CGRectMake(0, 0, screenWidth, screenHeight)] autorelease];		 
		 backgroundView.backgroundColor = background;		 		 
		 [self.view addSubview:backgroundView];
		 
	}	
	if(thTableView == nil){	
		CGRect bounds = self.view.bounds;
		//CGRect bounds = [[UIScreen mainScreen] bounds];
		//int screenWidth =  bounds.size.width;
		//int screenHeight =  bounds.size.height;
		
		thTableView = [[UITableView alloc] 
			initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height-50)
						style:UITableViewStyleGrouped];
		//thTableView.allowsSelection = NO;
		//thTableView.scrollEnabled = NO;
		//thTableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
		[thTableView setBackgroundView:nil]; 
		thTableView.backgroundColor = [UIColor clearColor];
		
		thTableView.delegate = self;
		thTableView.dataSource = self;
		//myTableView.sectionHeaderHeight = 2;
		NSLog(@"loadVeiw:%d",thTableView);
		[self.view addSubview:thTableView];		
		[thTableView release];			
	}
	
}


 - (void)viewDidLoad {
    [super viewDidLoad];
 
 // Uncomment the following line to display an Edit button in the
	 //navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	 
//	 thTableView.backgroundColor = [UIColor redColor];
	 
	 
 }
 

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSLog(@"viewWillAppear");
	
	if(thTableView == nil){
		NSLog(@"tableView == nil");
		[self doLoadVeiw];
	}
	
//	self.view.backgroundColor = [UIColor clearColor];
//	self.tableView.backgroundColor = [UIColor clearColor];
//	self.tableView.backgroundColor = background;//[UIColor clearColor];
	
	/*
	CGRect windowBounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  windowBounds.size.width;
	int screenHeight =  windowBounds.size.height;
	UIView *backgroundView = [[[UIView alloc] initWithFrame:
							   CGRectMake(0, 0, screenWidth, screenHeight)] autorelease];
	UIColor *background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
    backgroundView.backgroundColor = background;
	[self.view addSubview:backgroundView];
	
	//[self.view sendSubviewToBack: backgroundView];
	//[self.view bringSubviewToFront:self.tableView];
	//[self.view insertSubview:backgroundView atIndex:[self.view.subviews count]];
	*/
	//		
	
	if(data == nil){		
		
		data = [NSMutableArray array];
		
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:36553215], @"population", 
						 @"California", @"name", 
						 [NSNumber numberWithInt:163770], @"area", nil]];
		//END:code.states.california
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:23904380], @"population",
						 @"Texas", @"name", 
						 [NSNumber numberWithInt:268601], @"area", nil]];
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:19297729], @"population", 
						 @"New York", @"name", 
						 [NSNumber numberWithInt:54475], @"area", nil]];
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:18251243], @"population",
						 @"Florida", @"name", 
						 [NSNumber numberWithInt:65758], @"area", nil]];
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:12852548], @"population", 
						 @"Illinois", @"name", 
						 [NSNumber numberWithInt:57918], @"area", nil]];
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:683478], @"population", 
						 @"Alaska", @"name", 
						 [NSNumber numberWithInt:656425], @"area", nil]];
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:957861], @"population", 
						 @"Montana", @"name", 
						 [NSNumber numberWithInt:147046], @"area", nil]];
		[data addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:1969915], @"population",
						 @"New Mexico", @"name",
						 [NSNumber numberWithInt:121593], @"area", nil]];
		
		[thTableView reloadData];
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSLog(@"numberOfRowsInSection:%d",[data count]);

    return [data count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	NSLog(@"line:%@",[data objectAtIndex:indexPath.row]);
	
	cell.textLabel.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
	cell.image = [UIImage imageNamed: @"detail.png"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.backgroundColor = [UIColor clearColor];
	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.textLabel.opaque = NO;
	cell.textLabel.textColor = [UIColor darkGrayColor];
	cell.textLabel.highlightedTextColor = [UIColor whiteColor];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:22];
	
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.opaque = NO;
	cell.detailTextLabel.textColor = [UIColor darkGrayColor];
	cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:22];
	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	//if(section == 0)
	//	return tableView.tableHeaderView.frame.size.height;
	//else
	//	return 30;
	//UIImage     *image = [UIImage imageNamed: @"mp3.png"];
	//CGFloat h = image.size.height;
	//[image release];
	return MyTableHeaderHeight2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	CGRect windowBounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  windowBounds.size.width;
	
	UIView *headerView = [[[UIView alloc] initWithFrame:
						   CGRectMake(0, 44, screenWidth, MyTableHeaderHeight2)] autorelease];
	
//	UIColor *background = [UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]];
	//UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title.png"]];
	//[headerView addSubview: [background autorelease]];	
    headerView.backgroundColor = background;
	
	UIImage     *image = [UIImage imageNamed: @"page.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
	imageView.frame = CGRectMake((screenWidth-image.size.width)/2,
								 (MyTableHeaderHeight2-image.size.height)/2,
								 image.size.width, image.size.height);
	[headerView addSubview: [imageView autorelease]];
	//[myTableView setTableHeaderView: headerView];
	return headerView;	
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*NSUInteger row = [indexPath row];
	 NSString *text = @"";
	 if(controllers != nil){
	 DocumentDetailViewController *controller =  [controllers objectAtIndex:row];	
	 text = controller.title;	
	 }
	 CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
	 CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
	 CGFloat height = MAX(size.height, 44.0f);
	 return (height + (CELL_CONTENT_MARGIN * 2) - 19.0 + 2);*/
	
	return 65;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";//Lessons";		
}



@end

