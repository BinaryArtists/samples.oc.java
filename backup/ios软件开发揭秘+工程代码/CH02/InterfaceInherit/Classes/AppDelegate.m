//
//  AppDelegate.m
//  InterfaceInherit
//
//  Created by Henry Yu on 10-11-06.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "AppDelegate.h"
#import "SubClass.h"


@implementation AppDelegate


-(void)oldmessage:(NSString *)str{
	NSLog(@"oldmessage:%@",str);
}

- (void)newmessage:(NSString *)str{
	NSLog(@"newmessage:%@",str);
}

- (BOOL)application:(UIApplication *)application 
       didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	BaseClass *base = [[BaseClass alloc] init];
	base.delegate = self;
	[base oldmethod];
		
	SubClass *sub = [[SubClass alloc] init];
	sub.delegate = self;		
	[sub oldmethod];
	[sub newmethod:@""];
	
	return YES;
}

- (void)dealloc {    
    [super dealloc];
}


@end
