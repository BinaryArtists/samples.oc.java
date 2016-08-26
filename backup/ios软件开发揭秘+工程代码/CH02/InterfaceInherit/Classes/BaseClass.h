//
//  BaseClass.h
//  InterfaceInherit
//
//  Created by Henry Yu on 10-11-06.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseClassDelegate <NSObject>
-(void)oldmessage:(NSString *)str;
@end

@interface BaseClass : NSObject {
	id <BaseClassDelegate> delegate;
}

@property (nonatomic, assign) id <BaseClassDelegate> delegate;
-(void)oldmethod;
@end

