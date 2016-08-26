//
//  ClassWithProtocol.m
//  blogScratchApp
//
//  Created by Henry Yu 4/15/10.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "ClassWithProtocol.h"

@implementation ClassWithProtocol

@synthesize delegate;

- (void)processComplete
{
	//回调接口,processSuccessful()由使用者负责具体实现
	[[self delegate] processSuccessful:YES];
}

//通过定时器,模拟在任务完成时调用接口回调函数
- (void)startSomeProcess
{
	[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(processComplete) userInfo:nil repeats:YES];
}


@end
