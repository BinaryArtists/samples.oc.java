//
//  Observer.h
//  Observer
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Observer <NSObject>

@optional
- (void)update;

@end
