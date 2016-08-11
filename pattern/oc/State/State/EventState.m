//
//  EventState.m
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "EventState.h"
#import "Work.h"
#import "RestState.h"
#import "SleepState.h"

@implementation EventState

- (void)writeProgram:(Work *)work {
    if (work.finished) {
        work.state = [[RestState alloc] init];
        [work writeProgram];
    } else {
        if (work.hour < 21) {
            NSLog(@"当前时间：{%.f}点，加班哦，疲累之极", work.hour);
        } else {
            work.state = [[SleepState alloc] init];
            [work writeProgram];
        }
    }

}
@end
