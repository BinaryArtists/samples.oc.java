// 
//  Swizzle.m
//  MethodSwizzle
//
//  Created by Henry Yu on 10-11-05.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "Swizzle.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface SimpleClass: NSObject {	
}
- (void)print:(NSString*)str;
@end

@implementation SimpleClass
- (void)print:(NSString*)str{
	NSLog(@"%@",str);
}
@end

@implementation Swizzle

+ (void)swizzle:(Class)c oSelector:(SEL)orig Class:(Class)c2 aSelector:(SEL)new{		
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c2, new);
	BOOL added = class_addMethod(c, orig, method_getImplementation(newMethod),
								 method_getTypeEncoding(newMethod));
    if(added){
        class_replaceMethod(c, new, method_getImplementation(origMethod),
							method_getTypeEncoding(origMethod));
    }else{
		method_exchangeImplementations(origMethod, newMethod);
	}
}

- (void)swizzlePrint:(NSString*)str{
	NSLog(@"Swizzle:%@",str);
}

- (void)testSwizzle{
	SEL o = @selector(print:);
	SEL r = @selector(swizzlePrint:);
	
	SimpleClass *simple = [[SimpleClass alloc] init];
	[simple print:@"some string"];
			
	[Swizzle swizzle:[SimpleClass class] oSelector:o Class:[self class] aSelector:r];
	
	[simple print:@"some string"];
}



@end
