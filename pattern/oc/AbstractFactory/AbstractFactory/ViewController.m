//
//  ViewController.m
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import "ViewController.h"
#import "Factory.h"
#import "SqlserverFactory.h"
#import "AccessFactory.h"
#import "Department.h"
#import "User.h"

#import "SQLDepartment.h"
#import "SQLUser.h"
typedef id<Factory> Factory;
typedef id<Department> Department;
typedef id<User> User;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 抽象类：抽象工厂，抽象用户，抽象部门
    
    // 抽象工厂：创建用户，创建部门
    
    Factory factory = [[SqlserverFactory alloc]init]; // sql服务器的用户，sql服务器部门
    Department department = [factory createDepartment];
    [department insertDepartment:[[SQLDepartment alloc]init]];
    [department getDepartment];
    
    Factory factory1 = [[AccessFactory alloc]init]; // 访问用户，访问部门
    Department department1 = [factory1 createDepartment];
    [department1 insertDepartment:[[SQLDepartment alloc]init]];
    [department1 getDepartment];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
