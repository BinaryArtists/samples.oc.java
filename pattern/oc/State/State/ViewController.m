//
//  ViewController.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ViewController.h"
#import "Work.h"
#import "NoonState.h"
#import "AfternoonState.h"
#import "EventState.h"
#import "SleepState.h"
#import "RestState.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Work *work = [[Work alloc]init];
    [work writeProgram];
    
    work.state = [[AfternoonState alloc]init];
    [work writeProgram];
    
    work.state = [[EventState alloc]init];
    [work writeProgram];
    
    work.state = [[SleepState alloc]init];
    [work writeProgram];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
