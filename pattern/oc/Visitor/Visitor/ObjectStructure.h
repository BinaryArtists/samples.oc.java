//
//  ObjectStructure.h
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Elements;
@class Visitors;

@interface ObjectStructure : NSObject {
    NSMutableArray *elements;
}

- (void)attach:(Elements *)element;
- (void)detach:(Elements *)element;
- (void)accept:(Visitors *)visitor;

@end
