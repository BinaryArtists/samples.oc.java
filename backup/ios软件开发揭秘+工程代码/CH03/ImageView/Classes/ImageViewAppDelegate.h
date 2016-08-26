//
//  ImageViewAppDelegate.h
//  ImageView
//
//  Created by Henry Yu on 10-04-11.
//  Copyright 2011 Sevensoft Information Technology Ltd.(http://www.sevenuc.com)
//  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

