//
//  Work.h
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "State.h"

@interface Work : NSObject

@property(nonatomic,strong)id<State> state;
@property(nonatomic,assign)CGFloat hour;
@property(nonatomic,assign)BOOL finished;

- (void)writeProgram;

@end
