//
//  User.h
//  AbstractFactory
//
//  Created by yifan on 15/8/14.
//  Copyright (c) 2015年 fa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLUser.h"

@protocol User <NSObject>

-(void)insertUser:(SQLUser *)user;
-(SQLUser *)getUser;

@end
