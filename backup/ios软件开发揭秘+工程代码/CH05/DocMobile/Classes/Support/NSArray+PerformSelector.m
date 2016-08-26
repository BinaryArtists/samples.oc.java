//
//  NSArray+PerformSelector.m
//
//  Created by Henry Yu on 09-06-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import "NSArray+PerformSelector.h"


@implementation NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector {
    NSMutableArray * results = [NSMutableArray array];

    for (id object in self) {
        id result = [object performSelector:selector];
        [results addObject:result];
    }

    return results;
}

@end
