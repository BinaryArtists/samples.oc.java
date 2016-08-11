//
//  ViewController.m
//  Visitor
//
//  Created by fallenink on 15/8/27.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ViewController.h"
#import "ObjectStructure.h"
#import "ConcreteElementB.h"
#import "ConcreteElementA.h"
#import "ConcreteVisitor1.h"
#import "ConcreteVisitor2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ObjectStructure *o = [[ObjectStructure alloc]init];
    ConcreteElementA *eA = [ConcreteElementA new];
    ConcreteElementB *eB = [ConcreteElementB new];
    
    [o attach:eA];
    [o attach:eB];
    
    ConcreteVisitor1 *v1 = [ConcreteVisitor1 new];
    ConcreteVisitor2 *v2 = [ConcreteVisitor2 new];
    
    [o accept:v1];
    [o accept:v2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
