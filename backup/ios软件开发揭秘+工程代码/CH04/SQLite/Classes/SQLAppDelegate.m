//
//  SQLAppDelegate.m
//  SQLite
//
//  Created by Henry Yu on 11/1/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import "SQLAppDelegate.h"
#import "RootViewController.h"
#import "Coffee.h"

@implementation SQLAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize coffeeArray;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	//Copy database to the user's phone if needed.
	[self copyDatabaseIfNeeded];
	
	//Initialize the coffee array.
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.coffeeArray = tempArray;
	[tempArray release];
	
	//Once the db is copied, get the initial data to display on the screen.
	[Coffee getInitialDataToDisplay:[self getDBPath]];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	
	//Save all the dirty coffee objects and free memory.
	[self.coffeeArray makeObjectsPerformSelector:@selector(saveAllData)];
	
	[Coffee finalizeStatements];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    //Save all the dirty coffee objects and free memory.
	[self.coffeeArray makeObjectsPerformSelector:@selector(saveAllData)];
}

- (void)dealloc {
	[coffeeArray release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SQL.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}	
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"SQL.sqlite"];
}

- (void) removeCoffee:(Coffee *)coffeeObj {
	
	//Delete it from the database.
	[coffeeObj deleteCoffee];
	
	//Remove it from the array.
	[coffeeArray removeObject:coffeeObj];
}

- (void) addCoffee:(Coffee *)coffeeObj {
	
	//Add it to the database.
	[coffeeObj addCoffee];
	
	//Add it to the coffee array.
	[coffeeArray addObject:coffeeObj];
}

@end
