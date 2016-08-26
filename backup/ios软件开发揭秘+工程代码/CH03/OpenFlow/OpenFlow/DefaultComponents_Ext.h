//
//  DefaultComponents_Ext.h
//  mTime
//
//  Created by Alan Liu on 11/5/09.
//  Copyright 2009 illusionfans. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationBar (MTimeNavigationBar)

@end

@interface UIToolbar (MTimeToolbar)

@end

@interface UIImage (MTimeImage)

typedef enum {
	UIImageCornerPositionTop = 1,
	UIImageCornerPositionBottom
} UIImageCornerPosition;

- (UIImage*)imageWithBorderWidth:(CGFloat)width;

- (UIImage *)imageWithRoundCornerWidth:(int)cornerWidth Height:(int)cornerHeight Position:(UIImageCornerPosition)position;
@end