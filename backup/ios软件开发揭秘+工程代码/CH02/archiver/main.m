//
//  main.m
//  archiver
//
//  Created by Henry Yu on 10-11-05.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "Roster.h"

#define ARCHIVE 0
#define UNARCHIVE 1

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
 
	NSString *homePath = [[NSBundle mainBundle] executablePath];
	NSArray *strings = [homePath componentsSeparatedByString: @"/"];
	NSString *executableName  = [strings objectAtIndex:[strings count]-1];	
	NSString *baseDirectory = [homePath substringToIndex:
						   [homePath length]-[executableName length]-1];	
	
	NSString *fileName = [NSString stringWithFormat:@"%@/roster.archive",baseDirectory];
    NSLog(@"filePath: %@",fileName);
	
#if ARCHIVE	
	// create and archive a roster
	Roster *roster = [[Roster alloc] init];
	[roster create];
	[NSKeyedArchiver archiveRootObject:roster toFile:fileName];	
	[roster release];	
#endif
	
#if UNARCHIVE	
	// unarchive roster
	Roster *unarchive = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
	[unarchive print];
	for (Athlete *athlete in [unarchive athletes])
		[athlete print];
    [unarchive release];
#endif
		
    [pool release];
    return 0;
}
