//
//  FontListAppDelegate.h
//  FontList
//
//  Created by Henry Yu on 11/17/09.
//  Copyright Sevenuc.com 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontListAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

