//
//  SecreteSubject.m
//  Observer
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "ConcreteSubject.h"
#import "Observer.h"

@implementation ConcreteSubject

- (void)notify {
    NSLog(@"秘书通知：老板回来了，大家赶紧撤");
    
    for (id<Observer> observer in [self getobserverList]) {
        [observer update];
    }
}
@end
