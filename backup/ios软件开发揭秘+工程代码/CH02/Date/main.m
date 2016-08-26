//
//  main.m
//  Date
//
//  Created by Henry Yu on 09-01-29.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

void dateTimeTest(){
	//获取当前日期时间
	NSDate *dateToDay = [NSDate date];
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[df setLocale:locale];
	NSString *myDateString = @"2009-09-15 18:30:00";
	
	//从字符串生成日期对象
	NSDate *myDate = [df dateFromString: myDateString];
	
	//日期比较
	switch ([dateToDay compare:myDate]) {
		case NSOrderedSame:
			NSLog(@"These dates are the same!");
			break;
		case NSOrderedAscending:
			NSLog(@"dateToDay is earlier than myDate!");
			break;
		case NSOrderedDescending:
			NSLog(@"myDate is earlier than dateToDay!");
			break;
		default:				
			NSLog(@"Bad times. Invalid enum value returned.");
			break;
	}
	
}

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    dateTimeTest();
    [pool release];
    return 0;
}
