//
//  SleepState.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "SleepState.h"
#import "Work.h"

@implementation SleepState

- (void)writeProgram:(Work *)work {
    NSLog(@"当前时间：{%.f}点，不行了，睡着了", work.hour);
}
@end
