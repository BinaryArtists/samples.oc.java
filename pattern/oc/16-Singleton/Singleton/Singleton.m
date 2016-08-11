//
//  Singleton.m
//  Singleton
//
//  Created by yifan on 15/8/15.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+ (instancetype)sharedInstance {
    static Singleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[Singleton alloc]init];
    });
    return singleton;
}
@end
