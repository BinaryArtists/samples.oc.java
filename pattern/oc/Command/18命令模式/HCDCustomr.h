//
//  HCDCustomr.h
//  18命令模式
//
//  Created by yifan on 15/8/15.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HCDOrder,HCDMuttonOrder,HCDChickenOrder;
@interface HCDCustomr : NSObject
-(HCDOrder *)pushOrderWithString:(NSString *)string type:(BOOL)type;
@end
