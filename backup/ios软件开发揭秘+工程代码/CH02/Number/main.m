//
//  main.m
//  Number
//
//  Created by Henry Yu on 09-01-29.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

static void numberTest(){
	
	NSNumber *numObj = [NSNumber numberWithInt: 2];
	NSLog(@"numObj=%@",numObj); 
	NSInteger myInteger = [numObj integerValue];
	NSLog(@"myInteger=%d",myInteger); 
	int a = [numObj intValue];
	NSLog(@"a=%d",a);
	
	//浮点数值使用CGFloat,NSDecimalNumber对象进行处理:
	NSDecimalNumber *myDecimalObj = [[NSDecimalNumber alloc] initWithString:@"23.30"]; 
	NSLog(@"myDecimalObj doubleValue=%6.3f",[myDecimalObj doubleValue]); 
	
	CGFloat myCGFloatValue = 43.4; 
	NSDecimalNumber *myOtherDecimalObj = [[NSDecimalNumber alloc] initWithFloat:myCGFloatValue]; 
	NSLog(@"myOtherDecimalObj doubleValue=%6.3f",[myOtherDecimalObj doubleValue]);
	
}


int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	numberTest();	
    [pool release];
    return 0;
}
