//
//  DataSource.m
//  PagingScrollView
//
//  Created by Henry Yu on 6/4/10.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "DataSource.h"
#import "SynthesizeSingleton.h"

@implementation DataSource

SYNTHESIZE_SINGLETON_FOR_CLASS(DataSource);

//
// init
//
// Init method for the object.
//
- (id)init
{
	self = [super init];
	if (self != nil)
	{
		dataPages = [[NSArray alloc] initWithObjects:
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Page 1", @"pageName",
				@"Some text for page 1", @"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Page 2", @"pageName",
				@"Some text for page 2", @"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Page 3", @"pageName",
				@"Some text for page 3", @"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Page 4", @"pageName",
				@"Some text for page 4", @"pageText",
				nil],
			[NSDictionary dictionaryWithObjectsAndKeys:
				@"Page 5", @"pageName",
				@"Some text for page 5", @"pageText",
				nil],
			nil];
	}
	return self;
}

- (NSInteger)numDataPages
{
	return [dataPages count];
}

- (NSString *)dataForPage:(NSInteger)pageIndex
{
	return [NSString stringWithFormat:@"Page:%d", pageIndex];
}

@end
