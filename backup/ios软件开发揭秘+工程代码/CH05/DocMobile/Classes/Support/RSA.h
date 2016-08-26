//  RSA.h
//
//  Created by Henry Yu on 09-09-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/evp.h>
#import <openssl/rand.h>
#import <openssl/rsa.h>
#import <openssl/engine.h>
#import <openssl/sha.h>
#import <openssl/pem.h>
#import <openssl/bio.h>
#import <openssl/err.h>
#import <openssl/ssl.h>
#import <openssl/md5.h>


@interface SimpleCrypto : NSObject
{
    NSData *clearText;
	NSData *publicKey;
	NSData *privateKey;	
}

- (id)init;
- (NSString*)encrypt_string:(NSString*)cleartext PublicKey:(NSString*)pub;
- (NSString*)encrypt_string2:(NSString*)cleartext PublicKey:(NSString*)pub;
- (NSInteger)main_test;

@end
