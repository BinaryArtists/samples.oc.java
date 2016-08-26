//
//  CCAgent.h
//  ccworld
//
//  Created by Henry Yu on 10-11-07.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSThread.h>

@protocol CCAgentDelegate;
@interface CCAgent : NSObject {
   id <CCAgentDelegate> delegate;
}

@property (nonatomic,assign) id <CCAgentDelegate> delegate;

- (void)InitEngine;
- (void)StartEngine:(NSString*)str;
- (NSInteger)GetChannelList;
- (void) callbackInner;
@end

@protocol CCAgentDelegate <NSObject>
- (void)renderCompleted:(NSString *)msg;
@end
