//
//  SysColorViewController.m
//  ColorTable
//
//  Created by Henry Yu on 10-11-17.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "SysColorViewController.h"
#import "WebColorViewController.h"
#import <objc/runtime.h>

@implementation SysColorViewController

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)showWebViewController{
	WebColorViewController *webController = [[WebColorViewController alloc] init];
	webController.view.frame = self.view.bounds;
	[self.navigationController pushViewController:webController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

   	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Web Color" style:UIBarButtonItemStylePlain target:self action:@selector(showWebViewController)];
	self.navigationItem.rightBarButtonItem = backButton;
	[backButton release];
 
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if(!colorArray){		
		self.navigationItem.title = @"System Color";		
		
		// Get all class methods for UIColor.		
		unsigned int count = 0;
		Method *methods = class_copyMethodList(object_getClass([UIColor class]), &count);
		colorArray = [[NSMutableArray alloc] initWithCapacity:count];
		
		for (int i=0; i < count; i++) {
			// For each method, get the name and see if it ends in "Color"
			Method method = methods[i];
			SEL selector = method_getName(method);
			NSString *methodNameString = [NSString stringWithCString:(const char *)selector encoding:NSASCIIStringEncoding];
			if ([methodNameString hasSuffix:@"Color"]) {
				// If so, see if it returns an object.
				char returnType;
				method_getReturnType(method, &returnType, 1);
				BOOL doesReturnObject = (returnType == _C_ID);
				if (doesReturnObject) {
					[colorArray addObject:methodNameString];
				}
			}
		}
		
		if (methods) {
			free(methods);
		}    
		
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [colorArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *colorName = [colorArray objectAtIndex:[indexPath row]];
	SEL colorSelector = NSSelectorFromString(colorName);
	cell.textLabel.text = [NSString stringWithFormat:@"%s", colorSelector];
	//cell.textLabel.textColor = [UIColor performSelector:colorSelector withObject:nil];
	
	cell.detailTextLabel.numberOfLines = 2;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap; 
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n \n", colorName];
	cell.detailTextLabel.textColor = [UIColor performSelector:colorSelector withObject:nil];
	
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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

