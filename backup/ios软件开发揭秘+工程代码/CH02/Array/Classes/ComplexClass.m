//
//  ComplexClass.m
//  array
//
//  Created by Henry Yu on 10-11-03.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import "ComplexClass.h"
#import "Person.h"

@implementation ComplexClass

#pragma mark -
#pragma mark sorting
+ (void)simpleSorting{
	NSArray *persons = [NSArray arrayWithObjects:@"Henry",
	  @"Alex", @"Paul",@"Flank", @"Abel", 
		@"Jerry", @"Steven", @"John", nil];
	
	NSCountedSet *cset = [[NSCountedSet alloc] initWithArray:persons];
	NSArray *sorted = [[cset allObjects]
			sortedArrayUsingSelector:@selector(compare:)] ;
	NSLog(@"persons:%@",persons);
	NSLog(@"sorted:%@",sorted);	
	[cset release];
}

#pragma mark -
#pragma mark sorting array with descriptors
- (void)sortingPersonWithProperty:(NSString *)field{
	Person *person = [[Person alloc] init];
	NSMutableArray *personList = [person creatTempraryList];
	NSLog(@"------- Before Sorted Person By %@ ---------",field);
	[self printingPersonArray:personList];
	NSSortDescriptor *sorter = [[NSSortDescriptor alloc]
				initWithKey:field ascending:YES]; 
	[personList sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
	NSLog(@"------- After Sorted Person By %@ ---------",field);
	[self printingPersonArray:personList];
	[sorter release];
	[person release];
}

#pragma mark -
#pragma mark sorting array with function
- (void)customizeSortingTest{
	Person *person = [[Person alloc] init];
	NSMutableArray *personList = [person creatTempraryList];
	NSLog(@"----------before customizeSortingTest------------");
	[self printingPersonArray:personList];
	
	//Sorting using a selector
	NSArray *sortedArray = [personList sortedArrayUsingSelector:
				@selector(compareBirthDate:)];
	NSLog(@"----------after customizeSortingTest------------");
	[self printingPersonArray:sortedArray];	
	[person release];	
	
}

#pragma mark -
#pragma mark filter array using NSPredicate
- (void)filterPersonWithPredicate:(NSPredicate *)predicate{
	Person *person = [[Person alloc] init];
	NSMutableArray *personList = [person creatTempraryList];		
	NSLog(@"------------------- original array -------------------");
	[self printingPersonArray:personList];	
	//Case 1, NSArray provides filteredArrayUsingPredicate:  
	//which returns a new array containing objects in the receiver 
	//that match the specified predicate.
	
	NSPredicate *aPredicate = 
	 [NSPredicate predicateWithFormat:@"SELF.lastName beginswith[c] 'a'"];	
	NSArray *newArry = [personList filteredArrayUsingPredicate:aPredicate];
	//Get all person that lastname start with 'a'
	NSLog(@"filtered lastname begins with 'a':");
	[self printingPersonArray:newArry];
	
	//Case 2, NSMutableArray provides filterUsingPredicate: 
	//which evaluates the receiver’s content against the specified predicate
	//and leaves only objects that match.
	NSPredicate *cPredicate = 
	  [NSPredicate predicateWithFormat:@"SELF.lastName contains[c] 'a'"];
	[personList filterUsingPredicate:cPredicate];
	//Get all person that lastname contains 'e'
	NSLog(@"filtered lastname contains 'a': ");
	[self printingPersonArray:personList];
	
	//Case 3, 
	float salary = 740.0;
	NSPredicate *sPredicate = [NSPredicate 
							  predicateWithFormat:@"SELF.salary > %f", salary];
	[personList filterUsingPredicate:sPredicate];
	//Get all person that salary > 740
	NSLog(@"filtered salary > %f", salary);
	[self printingPersonArray:personList];
	
	//Case 4,
	NSString *match = @"Ahm*";
	//NSString *condition = @"SELF.lastName like[cd] %@";
	NSPredicate *kPredicate = [NSPredicate predicateWithFormat:
							  @"SELF.lastName like %@", match];
	[personList filterUsingPredicate:kPredicate];
	//Get all person that lastname similar with 'Ahm'
	NSLog(@"filtered lastname with like: %@", match);
	[self printingPersonArray:personList];
		
	[person release];
	
}

#pragma mark -
#pragma mark filter array using traditional method
- (void)removePersonWithLastName:(NSString *)fliterText{
	Person *person = [[Person alloc] init];
	NSMutableArray *personList = [person creatTempraryList];
	NSLog(@"before");
	[self printingPersonArray:personList];

	int i;
	for(i = 0; i < [personList count]; i++) {
		Person *element = [personList objectAtIndex:i];
		if([element.lastName isEqualToString:fliterText]) {
			[personList removeObjectAtIndex:i];
			i--;
		}
	}
	
	NSLog(@"after");
	[self printingPersonArray:personList];
	
	[person release];
}

#pragma mark -
#pragma mark filter array using traditional method 2
- (NSArray *)filterPersonWithLastName:(NSString *)fliterText{
	Person *person = [[Person alloc] init];
	NSMutableArray *personList = [person creatTempraryList];
	NSLog(@"before");
	[self printingPersonArray:personList];
	
	NSMutableArray *personsToRemove = [NSMutableArray array];
	for (Person *person in personList) {
		if (fliterText && [fliterText rangeOfString:person.lastName 
			options:NSLiteralSearch|NSCaseInsensitiveSearch].length == 0)
			[personsToRemove addObject:person];
	}	
	[personList removeObjectsInArray:personsToRemove];
	NSLog(@"after");
	[self printingPersonArray:personList];
	
	[person release];
	return personList;		
}

#pragma mark -
#pragma mark map operation on array
- (void)mapOperation{
	Person *person = [[Person alloc] init];
	NSMutableArray *oldArray = [person creatTempraryList];
	NSArray *newArray = [oldArray copy];
	[newArray makeObjectsPerformSelector:@selector(formatName)];
	NSLog(@"after mapOperation");
	[self printingPersonArray:newArray];
	[person release];
}

#pragma mark -
#pragma mark helpers
- (void)printingPersonArray:(NSArray *)array{
	for(Person *person in array){
		NSLog(@"Name: %@ %@ %@ (%.2f)",person.lastName,
		   person.firstName,person.birthDate,[person.salary floatValue]);
	}
	NSLog(@"-----------------------------------");
}


@end
