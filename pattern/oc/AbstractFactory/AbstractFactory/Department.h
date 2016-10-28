//
//  Department.h
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLDepartment.h"

@protocol Department <NSObject>

- (void)insertDepartment:(SQLDepartment *)department;
- (SQLDepartment *)getDepartment;

@end
