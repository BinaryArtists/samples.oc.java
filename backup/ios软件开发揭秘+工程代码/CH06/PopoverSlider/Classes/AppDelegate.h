//
//  AppDelegate.h
//  PopoverSlider
//
//  Created by Henry Yu on 10/27/10.
//  Copyright Sevenuc.com All rights reserved.
//

#import <UIKit/UIKit.h>
@class SliderViewController;
@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	SliderViewController *viewcontroller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SliderViewController *viewcontroller;;
@end

