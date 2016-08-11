//
//  Subject.h
//  Observer
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Observer.h"

@interface Subject : NSObject

- (void)attach:(id<Observer>)observer;
- (void)detach:(id<Observer>)observer;
- (void)notify;
- (NSArray *)getobserverList;

@end
