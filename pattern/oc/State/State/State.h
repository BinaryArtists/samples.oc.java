//
//  State.h
//  State
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Work;

@protocol State <NSObject>

- (void)writeProgram:(Work *)work;

@end
