//
//  UIView+Hierarchy.h
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Hierarchy)

-(int)getSubviewIndex;

-(void)bringToFront;
-(void)sentToBack;

-(void)bringOneLevelUp;
-(void)sendOneLevelDown;

-(BOOL)isInFront;
-(BOOL)isAtBack;

-(void)swapDepthsWithView:(UIView*)swapView;

@end