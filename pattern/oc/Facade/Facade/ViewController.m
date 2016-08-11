//
//  ViewController.m
//  Facade
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ViewController.h"
#import "Fund.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Fund *fund = [[Fund alloc]init];
    [fund buyFund];
    [fund sellFund];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
