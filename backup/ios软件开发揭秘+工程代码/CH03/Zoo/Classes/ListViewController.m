//
//  ListViewController.m
//  Zoo
//
//  Created by Henry Yu on 10-11-09.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "ListViewController.h"
#import "ZooAppDelegate.h"
#import "Animal.h"
#import "Category.h"
#import "DetailViewController.h"

@interface ListViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation ListViewController

@synthesize fetchedResultsController=fetchedResultsController_, 
            managedObjectContext=managedObjectContext_;
@synthesize iCurrentCategory;

#pragma mark -
#pragma mark View lifecycle
static int InitedData = 0;

- (void)loadView{
	[super loadView];
	
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	UIView *view = [[UIView alloc] initWithFrame: frame];
	self.navigationItem.title = @"Animal List";	
	self.view = view;	
	[view release];
	
	mainView = [[UIView alloc] initWithFrame: self.view.bounds];
	[self.view addSubview:mainView];
		
	ZooAppDelegate *appDelegate = (ZooAppDelegate*)[[UIApplication sharedApplication] delegate];
	self.managedObjectContext = appDelegate.managedObjectContext;
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	frame = CGRectMake(0,-2,screenWidth,screenHeight);
	
	theTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
	theTableView.dataSource = self;
	theTableView.delegate = self;
	[self.view addSubview:theTableView];
	
	//create data in store.
	if(!InitedData){
		InitedData = 1;
	    [self initAnimals];
	}
	
}

- (void)addAnimal{
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Set up the edit and add buttons.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
					initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
					target:self action:@selector(addAnimal)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];		
	
}


// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];	
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


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Animal *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  	UIImage *selimage = [UIImage imageWithData: object.image];
	cell.imageView.image = [self CreateThumbnail:selimage];
	cell.textLabel.text = object.name; 
	cell.detailTextLabel.text = object.name;
	//cell.detailTextLabel.numberOfLines = 1;
	//cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//[[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = 
	   [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView 
     commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
      forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here -- for example, create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
	Animal *object = (Animal *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[managedObject valueForKey:@"name"] description];
	DetailViewController *detailViewController =  [[DetailViewController alloc] init];
	[detailViewController initAnimal:object];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
	
	[NSFetchedResultsController deleteCacheWithName:@"Root"];
			
	
    /*
     Set up the fetched results controller.
	 */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"Animal" 
								   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
		
	//iCurrentCategory
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",category];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cid == %d",iCurrentCategory];
	[fetchRequest setPredicate:predicate];
	//[fetchedResultsController.fetchedObjects filteredArrayUsingPredicate:lastNameMatch];
	
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
										initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = 
	[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
										managedObjectContext:self.managedObjectContext 
										  sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return fetchedResultsController_;
}    


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    //[self.tableView beginUpdates];
	[theTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller 
     didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
			//[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
			//			  withRowAnimation:UITableViewRowAnimationFade];
			[theTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            //[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
			//			  withRowAnimation:UITableViewRowAnimationFade];
			[theTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] 
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    //UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [theTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[theTableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
							 withRowAnimation:UITableViewRowAnimationFade];
            [theTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
							 withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    //[self.tableView endUpdates];
	[theTableView endUpdates];
}


/*
 // Implementing the above methods to update the table view in response to 
 individual changes may have performance implications 
 if a large number of changes are made simultaneously. 
 If this proves to be an issue, you can instead just implement controllerDidChangeContent: 
 which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */


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
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
	[theTableView release];
	[mainView release];
    [super dealloc];
}

- (UIImage *)CreateThumbnail:(UIImage *)selectedImage{
	// Create a thumbnail version of the image for the event object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 44.0/size.width;
	}
	else {
		ratio = 44.0/size.height;
	}
	//CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	CGRect rect = CGRectMake(0.0, 0.0, 44*2, 44*2);
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return thumbnail;
	
}

#pragma mark -
#pragma mark Core Data management
- (Category *)createCategory:(int)i{
	Category *category =  
	[NSEntityDescription insertNewObjectForEntityForName:@"Category" 
					 inManagedObjectContext:self.managedObjectContext];
	// If appropriate, configure the new managed object.
    [category setUid:[NSNumber numberWithInt:i]];
	 [category setName:[NSString stringWithFormat:@"category%d",i]];
	 
	 NSError *error = nil;
	 if (![self.managedObjectContext save:&error]) {
	 	NSLog(@"Error: %@", [error localizedDescription]);
	 	return FALSE;
	 }	
	 return category;	 
}

- (void)initAnimals{
		    	
	Category *category = [self createCategory:1];
	
	int i = 0;	
	for(i = 1; i < 5; i++){
		NSString *name = [NSString stringWithFormat:@"animal%d",i];
		NSString *image = [NSString stringWithFormat:@"animal%d.jpg",i];		
		[self doAddAnimal:category Name:name Image:image];
	}	
	[category release];
	
	category = [self createCategory:2];
	for(i = 1; i < 5; i++){
		NSString *name = [NSString stringWithFormat:@"bird%d",i];
		NSString *image = [NSString stringWithFormat:@"bird%d.jpg",i];		
		[self doAddAnimal:category Name:name Image:image];
	}	
	[category release];
	
	category = [self createCategory:3];
	for(i = 1; i < 5; i++){
		NSString *name = [NSString stringWithFormat:@"fish%d",i];
		NSString *image = [NSString stringWithFormat:@"fish%d.jpg",i];		
		[self doAddAnimal:category Name:name Image:image];
	}
	[category release];
	
}

- (NSString *)getImagePath:(NSString *)imageName{
	NSString *homePath = [[NSBundle mainBundle] executablePath];
	NSArray *strings = [homePath componentsSeparatedByString: @"/"];
	NSString *executableName  = [strings objectAtIndex:[strings count]-1];	
	NSString *rawDirectory = [homePath substringToIndex:
							  [homePath length]-[executableName length]-1];
	NSString *baseDirectory = [rawDirectory stringByReplacingOccurrencesOfString:@" " 
																	  withString:@"%20"];
	NSString *imagePath = [NSString stringWithFormat:@"file://%@/%@",baseDirectory,imageName];	
    NSLog(@"imagePath: %@",imagePath);
	return imagePath;
}
	 
- (BOOL)doAddAnimal:(Category *)category Name:(NSString *)name Image:(NSString *)imageName{
	
	// Create a new instance of the entity managed by the fetched results controller.
    //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    //NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
	
	NSURL *url = [NSURL URLWithString: [self getImagePath:imageName]];
	NSData *imageData = [NSData dataWithContentsOfURL:url]; 	
		
    Animal *newAnimal  = 
	         [NSEntityDescription insertNewObjectForEntityForName:@"Animal" 
								  inManagedObjectContext:self.managedObjectContext];
	// If appropriate, configure the new managed object.
    [newAnimal setCategory:category];
	[newAnimal setCid:category.uid];
	[newAnimal setName:name];
	[newAnimal setImage:imageData];
	[newAnimal setDate:[NSDate date]];
	
    //NSError *error = nil;
	//if (![self.managedObjectContext save:&error]) {
	//	NSLog(@"Error: %@", [error localizedDescription]);
	//	return FALSE;
	//}
	
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {        
       NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
       abort();
    }	
	return TRUE;
	
}

- (NSArray *)fetchManagedObjectsWithPredicate{
	
	 NSFetchRequest *request = [[NSFetchRequest alloc] init];
	 NSEntityDescription *ent = [NSEntityDescription entityForName:@"Category" 
	 inManagedObjectContext:self.managedObjectContext];
	 [request setEntity:ent];
	 NSPredicate *pred = [NSPredicate predicateWithFormat:@"uid == %d",iCurrentCategory];
	 [request setPredicate:pred];
	 NSArray *objects = [self.managedObjectContext executeFetchRequest:request error:NULL];
	 Category* category = (Category *)[objects objectAtIndex:0];
	 [request release];
	 
	 for(Animal* a in category.animals){
	    NSLog(@"Animal %@ in Category:%d", a.name ,iCurrentCategory);
	 }		
	 return objects;
}

- (void)clearManagedObjectsWithPredicate:(NSManagedObject*)except{
	//NSPredicate * allExcept = [NSPredicate predicateWithFormat:@"SELF != %@", exception];
	//NSArray *objects = [self fetchMyManagedObjectsWithPredicateOrNil:nil];	
	NSArray *objects = [self fetchManagedObjectsWithPredicate];	
	for (NSManagedObject *object in objects) {
		[self.managedObjectContext deleteObject:object];
	}	
}


@end

