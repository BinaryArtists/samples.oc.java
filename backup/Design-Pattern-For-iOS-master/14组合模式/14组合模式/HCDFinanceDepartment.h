//
//  HCDFinanceDepartment.h
//  14组合模式
//
//  Created by 黄成都 on 15/8/15.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCDCompany.h"
@interface HCDFinanceDepartment : NSObject<HCDCompany>
@property(nonatomic,copy)NSString *name;
-(instancetype)initWithName:(NSString *)name;
@end