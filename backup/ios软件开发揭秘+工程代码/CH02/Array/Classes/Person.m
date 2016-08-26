//
//  Person.m
//  array
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "Person.h"


@implementation Person
@synthesize firstName,lastName,salary,birthDate;

- (NSDate *)makeBirthDate:(NSString *)birthDay{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd"];
	NSLocale *locale = 
	   [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	[df setLocale:locale];	
	NSDate *date = [df dateFromString: birthDay];
    [df release],[locale release];
	return date;
}

- (NSMutableArray *)creatTempraryList{
	NSMutableArray *personList = 
	  [[[NSMutableArray alloc] init] autorelease];
	//Creating a temparay objects of Person
	Person *personObj = [[Person alloc] init];
	personObj.firstName = @"Adeem";
	personObj.lastName = @"Basraa";
	personObj.salary = [NSNumber numberWithFloat:762.60];
	personObj.birthDate = [self makeBirthDate:@"1965-05-23"];
	
	[personList addObject:personObj];
	[personObj release];
	
	personObj = [[Person alloc] init];
	personObj.firstName = @"Ijaz";
	personObj.lastName = @"Ahmed";
	personObj.salary = [NSNumber numberWithFloat:750.02];
	personObj.birthDate = [self makeBirthDate:@"1967-09-06"];
	
	[personList addObject:personObj];
	[personObj release];
	
	personObj = [[Person alloc] init];
	personObj.firstName = @"Waqas";
	personObj.lastName = @"Noora";
	personObj.salary = [NSNumber numberWithFloat:733.67];
	personObj.birthDate = [self makeBirthDate:@"1971-10-26"];
	
	[personList addObject:personObj];
	[personObj release];
	
	personObj = [[Person alloc] init];
	personObj.firstName = @"Zeshan";
	personObj.lastName = @"Ali";
	personObj.salary = [NSNumber numberWithFloat:736.50];
	personObj.birthDate = [self makeBirthDate:@"1969-03-24"];
	
	[personList addObject:personObj];
	[personObj release];
	
	
	personObj = [[Person alloc] init];
	personObj.firstName = @"Faheem";
	personObj.lastName = @"Riaz";
	personObj.salary = [NSNumber numberWithFloat:711.35];
	personObj.birthDate = [self makeBirthDate:@"1982-10-22"];
	
	[personList addObject:personObj];
	[personObj release];
		
	personObj = [[Person alloc] init];
	personObj.firstName = @"Ali";
	personObj.lastName = @"Osama";
	personObj.salary = [NSNumber numberWithFloat:715.02];
	personObj.birthDate = [self makeBirthDate:@"1978-11-06"];
	
	[personList addObject:personObj];
	[personObj release];
	
	return personList;
}

- (void)formatName{
	firstName = [NSString stringWithFormat:@"%@]",firstName];
	lastName = [NSString stringWithFormat:@"[%@ ",lastName];	
}

- (NSInteger)compareBirthDate:(Person *)another{
	//Here you can customize any task for sorting.
	NSComparisonResult compareResult = 
	  [self.birthDate compare:another.birthDate];
	if(compareResult == NSOrderedSame)return 0;
	if(compareResult == NSOrderedAscending) return -1;
	else	return 1;    
}

- (void)dealloc {
	[super dealloc];
}

@end
