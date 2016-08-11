//
//  NoonState.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "NoonState.h"
#import "AfternoonState.h"
#import "Work.h"

@implementation NoonState

- (void)writeProgram:(Work *)work {
    if (work.hour < 13) {
        NSLog(@"当前时间：{%.f}点，饿了，午饭；犯困，午休", work.hour);
    } else {
        work.state = [[AfternoonState alloc] init];
        [work writeProgram];
    }
}
@end
