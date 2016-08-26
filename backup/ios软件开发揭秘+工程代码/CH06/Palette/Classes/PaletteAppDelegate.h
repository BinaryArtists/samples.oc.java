//
//  PaletteAppDelegate.h
//  Palette
//
//  Created by Henry Yu on 10-11-15.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ColorPickerViewController;
@interface PaletteAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIPopoverController *popover;
	ColorPickerViewController *viewController;
	UIButton *button;
}

@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UIWindow *window;
- (IBAction) showColorPickerViewController;

@end

