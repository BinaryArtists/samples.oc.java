//
//  Swizzle.h
//  MethodSwizzle
//
//  Created by Henry Yu on 10-11-05.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Swizzle : NSObject {

}

+ (void)swizzle:(Class)c oSelector:(SEL)orig Class:(Class)c2 aSelector:(SEL)new;
- (void)testSwizzle;
	
@end

