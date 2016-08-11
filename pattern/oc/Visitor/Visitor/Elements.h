//
//  Elements.h
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Visitors;

@interface Elements : NSObject

- (void)accept:(Visitors *)visitor;

@end
