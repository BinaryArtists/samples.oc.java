//
//  Fund.m
//  Facade
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "Fund.h"
#import "stock1.h"
#import "stock2.h"
#import "stock3.h"

@interface Fund()

@property(nonatomic,strong) stock1 *stock1;
@property(nonatomic,strong) stock2 *stock2;
@property(nonatomic,strong) stock3 *stock3;

@end

@implementation Fund

- (instancetype)init {
    self = [super init];
    if (self) {
        _stock1 = [[stock1 alloc]init];
        _stock2 = [[stock2 alloc]init];
        _stock3 = [[stock3 alloc]init];
    }
    return self;
}

- (void)buyFund {
    [self.stock1 buy];
    [self.stock2 buy];
    [self.stock3 buy];
}

- (void)sellFund {
    [self.stock1 sell];
    [self.stock2 sell];
    [self.stock3 sell];
}
@end
