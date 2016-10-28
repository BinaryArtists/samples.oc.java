//
//  SqlserverUser.m
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import "SqlserverUser.h"

@implementation SqlserverUser

- (SQLUser *)getUser {
    NSLog(@"新建一个Sqlserver的SQLUser对象");
    return [[SQLUser alloc]init];
}

- (void)insertUser:(SQLUser *)user {
     NSLog(@"插入一个Sqlserver的SQLUser对象");
}
@end
