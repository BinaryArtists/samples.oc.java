//
//  HCDConcreteElementA.m
//  23访问者模式
//
//  Created by 黄成都 on 15/8/27.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import "HCDConcreteElementA.h"
#import "HCDVisitors.h"
@implementation HCDConcreteElementA
-(void)operationA{
    return;
}
-(void)accept:(HCDVisitors *)visitor{
    [visitor VisitConcreteElementA:self];
}
@end
