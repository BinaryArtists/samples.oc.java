//
//  SubClass.h
//  InterfaceInherit
//
//  Created by Henry Yu on 10-11-06.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseClass.h"

@protocol SubClassDelegate <BaseClassDelegate, NSObject>
@optional
- (void)newmessage:(NSString *)str;
@end

@interface SubClass : BaseClass {	
}

@property (nonatomic,assign) id <SubClassDelegate> delegate;
- (void)newmethod:(NSString *)str;

@end

