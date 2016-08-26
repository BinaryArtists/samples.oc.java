//
//  SimpleClass.h
//  array
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleClass : NSObject {

}

- (void)sortOperation;
- (void)commonOperation;
- (void)commonOperation2;
- (void)mapOperation;
- (void)readWritePlist:(BOOL)readonly;
- (NSArray *)map:(SEL)selector Array:(NSArray *)array;

@end

