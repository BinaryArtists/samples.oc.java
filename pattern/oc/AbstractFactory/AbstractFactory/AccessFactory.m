//
//  AccessFactory.m
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import "AccessFactory.h"
#import "AccessDepartment.h"
#import "AccessUser.h"

@implementation AccessFactory

- (id<User>)createUser {
    return [[AccessUser alloc]init];
}
- (id<Department>)createDepartment {
    return [[AccessDepartment alloc]init];
}
@end
