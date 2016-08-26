//
//  NSArray+PerformSelector.h
//  
//  Created by Henry Yu on 09-06-03.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (PerformSelector)

- (NSArray *)arrayByPerformingSelector:(SEL)selector;

@end
