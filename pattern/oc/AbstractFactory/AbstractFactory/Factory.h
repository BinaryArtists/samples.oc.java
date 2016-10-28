//
//  Factory.h
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Department.h"

@protocol Factory <NSObject>

- (id<User>)createUser;
- (id<Department>)createDepartment;

@end
