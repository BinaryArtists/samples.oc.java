//
//  NSObject+CDD.m
//  CDDDemo
//
//  Created by gao feng on 16/2/4.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import "NSObject+CDD.h"
#import "CDDContext.h"
#import <objc/runtime.h>

@implementation NSObject (CDD)
@dynamic context;

- (void)setContext:(CDDContext*)object {
    objc_setAssociatedObject(self, @selector(context), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CDDContext*)context {
    return objc_getAssociatedObject(self, @selector(context));
}

+ (void)swizzleInstanceSelector:(SEL)oldSel withSelector:(SEL)newSel
{
    Method oldMethod = class_getInstanceMethod(self, oldSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!oldMethod || !newMethod)
    {
        return;
    }
    
    class_addMethod(self,
                    oldSel,
                    class_getMethodImplementation(self, oldSel),
                    method_getTypeEncoding(oldMethod));
    class_addMethod(self,
                    newSel,
                    class_getMethodImplementation(self, newSel),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, oldSel),
                                   class_getInstanceMethod(self, newSel));
}

@end
