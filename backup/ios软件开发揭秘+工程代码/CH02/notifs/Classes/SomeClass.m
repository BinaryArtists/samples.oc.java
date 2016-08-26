//  SomeClass.m
//
//  Copyright 2010 Sevenuc.com. All rights reserved. 
//
#import "SomeClass.h"
#import "notifsAppDelegate.h"

#pragma mark -
#pragma mark Private Interface

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Private interface definitions
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
@interface SomeClass (private)
- (void) dataDownloadComplete:(NSNotification *)notif;
@end


@implementation SomeClass

#pragma mark -
#pragma mark Private Methods

/*---------------------------------------------------------------------------
* Notifications of data downloads 
*--------------------------------------------------------------------------*/
- (void)downloadDataComplete:(NSNotification *)notif 
{
  NSLog(@"1,Received Time:%@",[NSDate date]);
	[NSThread sleepForTimeInterval:5];
  NSLog(@"2,Received Time:%@",[NSDate date]);
	
}

#pragma mark -
#pragma mark Initialization

/*---------------------------------------------------------------------------
* Initialization
*--------------------------------------------------------------------------*/
- (void) init
{
  // Register observer for when download of data is complete
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadDataComplete:) name:NOTIF_DataComplete object:nil]; 

}

#pragma mark -
#pragma mark Cleanup

/*---------------------------------------------------------------------------
* Cleanup 
*--------------------------------------------------------------------------*/ 
- (void)dealloc 
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}

@end
