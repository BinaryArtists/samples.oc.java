//
//  Work.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "Work.h"
#import "ForenoonState.h"

@implementation Work

- (instancetype)init {
    self = [super init];
    if (self) {
        self.state = [[ForenoonState alloc]init];
    }
    return self;
}

- (void)writeProgram {
    [self.state writeProgram:self];
}

@end
