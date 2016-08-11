//
//  RestState.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "RestState.h"
#import "Work.h"

@implementation RestState

- (void)writeProgram:(Work *)work {
    NSLog(@"当前时间：{%.f}点，下班回家了", work.hour);
}

@end
