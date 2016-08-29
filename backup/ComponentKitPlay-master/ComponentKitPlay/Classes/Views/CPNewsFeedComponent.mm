//
//  CPNewsFeedComponent.m
//  ComponentKitPlay
//
//  Created by xiekw on 15/5/20.
//  Copyright (c) 2015年 Modudu. All rights reserved.
//

#import "CPNewsFeedComponent.h"
#import <ComponentKit/CKInsetComponent.h>
#import <ComponentKit/CKStackLayoutComponent.h>
#import <ComponentKit/CKLabelComponent.h>
#import <ComponentKit/CKButtonComponent.h>
#import <ComponentKit/CKStackLayoutComponent.h>

@implementation CPNewsFeedComponent

+ (instancetype)newWithFeed:(CPNewsFeed *)feed {
    return [super newWithComponent:
            [CKStackLayoutComponent
             newWithView:{}
             size:{}
             style:{}
             children:{
                 {
                     [CKLabelComponent
                      newWithLabelAttributes:{
                          .string = @"child1",
                          .font = [UIFont fontWithName:@"Baskerville" size:30]
                      }
                      viewAttributes:{
                          {@selector(setBackgroundColor:), [UIColor clearColor]},
                          {@selector(setUserInteractionEnabled:), @NO},
                      }],
                     .alignSelf = CKStackLayoutAlignSelfCenter
                 },
                 {
                     [CKLabelComponent
                      newWithLabelAttributes:{
                          .string = @"child2",
                          .font = [UIFont systemFontOfSize:20.0]
                      }
                      viewAttributes:{
                          {@selector(setBackgroundColor:), [UIColor orangeColor]},
                      }],
                     .alignSelf = CKStackLayoutAlignSelfStretch
                 }
             }]];
}

@end
