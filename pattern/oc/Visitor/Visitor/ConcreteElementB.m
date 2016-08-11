//
//  ElementB.m
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ConcreteElementB.h"
#import "Visitors.h"

@implementation ConcreteElementB

- (void)operationB {
    return;
}

- (void)accept:(Visitors *)visitor {
    [visitor VisitConcreteElementB:self];
}
@end
