//
//  ConcreteVisitor1.m
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ConcreteVisitor1.h"
#import "ConcreteElementA.h"

@implementation ConcreteVisitor1

- (void)VisitConcreteElementA:(ConcreteElementA *)concreteElementA {
    NSString *eleName = NSStringFromClass([concreteElementA class]);
    
    NSString *visitorName = NSStringFromClass([self class]);
    
    NSLog(@"%@被%@访问",eleName, visitorName);
}

@end
