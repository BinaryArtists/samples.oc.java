//
//  AppDelegate.h
//  MoviePlayer
//
//  Created by Henry Yu on 3/27/10.
//  Copyright Sevenuc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoviePlayerViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MoviePlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MoviePlayerViewController *viewController;

@end

