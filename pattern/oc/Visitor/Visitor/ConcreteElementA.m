//
//  ConcreteElementA.m
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ConcreteElementA.h"
#import "Visitors.h"

@implementation ConcreteElementA

- (void)operationA {
    return;
}

- (void)accept:(Visitors *)visitor {
    [visitor VisitConcreteElementA:self];
}
@end
