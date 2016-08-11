//
//  ConcreteVisitor2.m
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ConcreteVisitor2.h"
#import "ConcreteElementB.h"

@implementation ConcreteVisitor2

- (void)VisitConcreteElementB:(ConcreteElementB *)concreteElementB {
    NSString *eleName = NSStringFromClass([concreteElementB class]);
    NSString *visitorName = NSStringFromClass([self class]);
    
    NSLog(@"%@被%@访问",eleName, visitorName);
}

@end
