//
//  test_appAppDelegate.h
//  test-app
//
//  Copyright Sevenuc.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassWithProtocol.h"

@class testAppObject;

@interface TestAppDelegate : NSObject <UIApplicationDelegate, ProcessDataDelegate>
{
  UIWindow *window;
  ClassWithProtocol *protocolTest;
}

@property (nonatomic, retain) UIWindow *window;

@end

