//
//  AccessDepartment.m
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import "AccessDepartment.h"

@implementation AccessDepartment

- (SQLDepartment *)getDepartment {
    NSLog(@"新建一个Access的SQLDepartment对象");
    return [[SQLDepartment alloc]init];
}

- (void)insertDepartment:(SQLDepartment *)department {
    NSLog(@"插入一个Access的SQLDepartment对象");
}
@end
