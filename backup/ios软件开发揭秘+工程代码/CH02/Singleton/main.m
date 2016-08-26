//
//  main.m
//  singleton
//
//  Created by Henry Yu on 10-11-01.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyManager.h"
int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	MyManager* manager = [MyManager instance];
	[manager test];
	[[MyManager instance] test];
    [pool release];
    return 0;
}
