//
//  String_NSArrayExtension.m
//
//  Created by Henry Yu on 09-09-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//  All rights reserved.
//


#import "NSString+NSArrayExtension.h"

@implementation NSString(NSArrayExtension)

+ (id)stringWithFormat:(NSString *)format array:(NSArray*) arguments;
{
    char *argList = (char *)malloc(sizeof(NSString *) * [arguments count]);
    [arguments getObjects:(id *)argList];
    NSString* result = [[NSString alloc] initWithFormat:format arguments:argList];
    free(argList);
    return [result autorelease];
}

@end
