//
//  SomeClass.h
//  property
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SomeClass : NSObject {
	BOOL      reloadFiles;
	NSInteger myCurrentPage;
	NSString       *hashCode;  
	NSMutableArray *directionArray;
	NSDictionary   *dictDetail;
}

@property BOOL      reloadFiles;
@property NSInteger myCurrentPage;
@property(nonatomic, retain)NSString       *hashCode;  
@property(nonatomic, retain)NSMutableArray *directionArray;
@property(nonatomic, retain)NSDictionary   *dictDetail;

- (void)printProperties;
@end
