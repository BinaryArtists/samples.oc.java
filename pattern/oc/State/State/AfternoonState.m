//
//  AfternoonState.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "AfternoonState.h"
#import "EventState.h"
#import "Work.h"

@implementation AfternoonState

- (void)writeProgram:(Work *)work {
    if (work.hour < 17) {
        NSLog(@"当前时间：{%.f}点，下午状态还不错，继续努力", work.hour);
    } else {
        work.state = [[EventState alloc] init];
        [work writeProgram];
    }
}
@end
