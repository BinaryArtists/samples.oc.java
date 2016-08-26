//
//  SomeClass+Wrapper.h
//  CategoryProtocol
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SomeClass.h"

@interface SomeClass (Wrapper) <SomeClassDelegate>
- (void)method;
@end