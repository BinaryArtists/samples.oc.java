//
//  IndicatorCell.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IndicatorCell : UITableViewCell
{
    BOOL useDarkBackground;
    UIImage *icon;
	NSString *Id;
	NSString *Description;
	NSString *Name;
	NSString *Value;	
    NSString *ActualState;
}

@property BOOL useDarkBackground;
@property(retain) UIImage *icon;
@property(retain) NSString *Id;
@property(retain) NSString *Name;
@property(retain) NSString *Description;
@property(retain) NSString *Value;
@property(retain) NSString *ActualState;

- (void)setState:(NSString *)state;
@end
