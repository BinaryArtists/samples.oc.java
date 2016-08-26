//
//  NSOperationTestAppDelegate.h
//  NSOperationTest
//
//  Created by Henry Yu on 10-11-02.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "LongTaskOperation.h"

@interface NSOperationTestAppDelegate : NSObject 
    <UIApplicationDelegate,LongTaskOperationDelegate> {  
	NSOperationQueue *mQueue;
}


@end

