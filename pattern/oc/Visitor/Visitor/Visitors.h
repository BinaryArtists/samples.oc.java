//
//  Visitors.h
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConcreteElementA, ConcreteElementB;

@interface Visitors : NSObject

- (void)VisitConcreteElementA:(ConcreteElementA *)concreteElementA;
- (void)VisitConcreteElementB:(ConcreteElementB *)concreteElementB;

@end
