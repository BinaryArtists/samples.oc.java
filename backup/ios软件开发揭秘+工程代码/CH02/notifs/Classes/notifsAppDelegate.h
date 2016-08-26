//  notifsAppDelegate.h
//
//  Copyright 2010 Sevenuc.com. All rights reserved. 
//
#import <UIKit/UIKit.h>

// For name of notification
extern NSString * const NOTIF_DataComplete;

@interface notifsAppDelegate : NSObject <UIApplicationDelegate> 
{
  UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

