//
//  ObjectStructure.m
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ObjectStructure.h"
#import "Elements.h"
#import "Visitors.h"

@implementation ObjectStructure

- (instancetype)init {
    self = [super init];
    if (self) {
        elements = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)attach:(Elements *)element {
    [elements addObject:element];
}

- (void)detach:(Elements *)element {
    [elements removeObject:element];
}

- (void)accept:(Visitors *)visitor {
    for (Elements *e in elements) {
        [e accept:visitor];
    }
}
@end
