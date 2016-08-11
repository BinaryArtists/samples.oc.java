//
//  ForenoonState.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ForenoonState.h"
#import "Work.h"
#import "NoonState.h"

@implementation ForenoonState

- (void)writeProgram:(Work *)work {
    if (work.hour < 12) {
         NSLog(@"当前时间：{%.f}点，上午工作，精神百倍", work.hour);
    }else{
        work.state = [[NoonState alloc] init];
        [work writeProgram];
    }
}
@end
