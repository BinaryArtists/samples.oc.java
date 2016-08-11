//
//  Subject.m
//  Observer
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "Subject.h"

@interface Subject ()

@property(nonatomic, readwrite, strong) NSMutableArray *observerList;

@end


@implementation Subject

- (instancetype)init {
    self = [super init];
    if (self) {
        _observerList = [NSMutableArray array];
    }
    return self;
}

- (void)attach:(id<Observer>)observer {
    [self.observerList addObject:observer];
}

- (void)detach:(id<Observer>)observer {
    for (id<Observer> currentObserver in [self getobserverList]) {
        if (currentObserver == observer) {
            [self.observerList removeObject:observer];
        }
    }
}

- (NSMutableArray *)getobserverList {
    return [NSMutableArray arrayWithArray:self.observerList];
}

- (void)notify {
    
}
@end
