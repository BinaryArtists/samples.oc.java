//
//  SQLAppDelegate.h
//  SQLite
//
//  Created by Henry Yu on 11/1/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Coffee;

@interface SQLAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	//To hold a list of Coffee objects
	NSMutableArray *coffeeArray;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSMutableArray *coffeeArray;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) removeCoffee:(Coffee *)coffeeObj;
- (void) addCoffee:(Coffee *)coffeeObj;

@end

