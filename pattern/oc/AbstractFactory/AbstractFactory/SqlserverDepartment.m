//
//  SqlserverDepartment.m
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import "SqlserverDepartment.h"

@implementation SqlserverDepartment

- (SQLDepartment *)getDepartment {
    NSLog(@"新建一个Sqlserver的SQLDepartment对象");
    
    return [[SQLDepartment alloc]init];
}

- (void)insertDepartment:(SQLDepartment *)department {
    NSLog(@"插入一个Sqlserver的SQLDepartment对象");
}
@end
