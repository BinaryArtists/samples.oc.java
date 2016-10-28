//
//  UserFactory.m
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import "SqlserverFactory.h"
#import "SqlserverUser.h"
#import "SqlserverDepartment.h"

@implementation SqlserverFactory
-(id<User>)createUser{
    return [[SqlserverUser alloc]init];
}
-(id<Department>)createDepartment{
    return [[SqlserverDepartment alloc]init];
}

@end
