//  ApplicationCell.h
//  WebDoc
//
//  Created by Henry Yu on 09-06-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ApplicationCell : UITableViewCell
{
    BOOL useDarkBackground;
    UIImage *icon;
    NSString *code;
    NSString *name;
}

@property BOOL useDarkBackground;

@property(retain) UIImage *icon;
@property(retain) NSString *code;
@property(retain) NSString *name;


@end
