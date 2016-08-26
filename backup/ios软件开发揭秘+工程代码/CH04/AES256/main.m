//
//  main.m
//  AES256
//
//  Created by Henry Yu on 10-04-08.
//  Copyright 2010 Sevensoft(http://www.sevenuc.com).
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+AES256.h"
#import "NSData+Base64.h"

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    	
	NSString *key = @"aes-sevensoft";
		
	NSData *plain = [@"2009-06-16 18:30:00" dataUsingEncoding:NSUTF8StringEncoding];
	NSData *eData = [plain AES256EncryptWithKey:key];	
	NSString *secretString = [eData base64EncodedString];
	NSLog(@"encrypted string:%@",secretString);	
		
	NSString *enString = [NSString stringWithString:secretString];		
	NSData *cipher = [NSData dataFromBase64String:enString]; 
	NSData *bDecrypt = [cipher AES256DecryptWithKey:key];
	NSString *dateString = [[NSString alloc] initWithData:bDecrypt encoding:NSASCIIStringEncoding];
	NSLog(@"decrypted string:%@",dateString);	
	
	
    [pool release];
    return 0;
}
