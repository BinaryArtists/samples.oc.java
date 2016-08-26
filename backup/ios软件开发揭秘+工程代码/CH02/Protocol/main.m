//
//  main.m
//  test-app
//
//  Created by Henry Yu 6/26/09.
//  Copyright Sevenuc.com All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"TestAppDelegate");
    [pool release];
    return retVal;
}
