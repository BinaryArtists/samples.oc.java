//
//  HCDSubject.h
//  Observer
//
//  Created by yifan on 15/8/13.
//  Copyright (c) 2015年 fallenink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDObserver.h"
@interface HCDSubject : NSObject
//这里很不合理，不知怎么办
//@property(nonatomic,readwrite,strong)NSMutableArray *observerList;
-(void)attach:(id<HCDObserver>)observer;
-(void)detach:(id<HCDObserver>)observer;
-(void)notify;
-(NSArray *)getobserverList;
@end
