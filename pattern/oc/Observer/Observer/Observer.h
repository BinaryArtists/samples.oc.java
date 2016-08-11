//
//  HCDObserver.h
//  Observer
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HCDObserver <NSObject>
@optional
-(void)update;
@end
