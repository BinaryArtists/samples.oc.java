//
//  DatePickerAppDelegate.h
//  DatePicker
//
//  Created by Henry Yu on 10-11-06.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCDatePicker.h"

@interface DatePickerAppDelegate : NSObject 
      <UIApplicationDelegate, UCDatePickerDelegate> {
    UIWindow *window;		
	UCDatePicker *birthDate;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UCDatePicker *birthDate;


@end

