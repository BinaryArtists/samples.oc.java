//
//  SomeClass.h
//  CategoryProtocol
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SomeClassDelegate;

@interface SomeClass : NSObject {	
	id <SomeClassDelegate> delegate;	
}
@property (nonatomic,assign) id <SomeClassDelegate> delegate;
@end

@protocol SomeClassDelegate <NSObject>
- (void)method;
@end

