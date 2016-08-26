//
//  main.m
//  NSData
//
//  Created by Henry Yu on 09-01-29.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>


void NSDatatTest(){
	//NSData 转换为NSString
	NSMutableData *data = nil;
	NSString *tmpdata = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSLog(@"[***] DATA:%@",tmpdata);	
	[tmpdata release];
	
	//NSString 转换为 NSData 
	NSString* str= @"teststring";
	NSData* tdata=[str dataUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"[***] tdata:%@",tdata);
}

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSDatatTest();
	
    [pool release];
    return 0;
}
