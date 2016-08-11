//
//  ViewController.m
//  Observer
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ViewController.h"
#import "Observer.h"
#import "NBAObserver.h"
#import "StockObserver.h"
#import "ConcreteSubject.h"

typedef id<Observer> Observer;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     iOS api 或 第三方火爆库，提供的观察者模式
     
     1. KVO
     2. ReactCocoa
     */
    
    Subject *subject = [[ConcreteSubject alloc]init];
    
    //添加三个通知对象
    Observer nbaobserver = [[NBAObserver alloc]init];
    [subject attach:nbaobserver];
    
    Observer stockobserver = [[StockObserver alloc]init];
    [subject attach:stockobserver];
    
    Observer stockobserver1 = [[StockObserver alloc]init];
    [subject attach:stockobserver1];
    
    //删除一个通知对象
    [subject detach:stockobserver];
    
    [subject notify];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
