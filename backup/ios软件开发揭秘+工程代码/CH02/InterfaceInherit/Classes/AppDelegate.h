//
//  AppDelegate.h
//  InterfaceInherit
//
//  Created by Henry Yu on 10-11-06.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//


#import "BaseClass.h"

@interface AppDelegate :NSObject 
       <UIApplicationDelegate,BaseClassDelegate> {    
}

@end

