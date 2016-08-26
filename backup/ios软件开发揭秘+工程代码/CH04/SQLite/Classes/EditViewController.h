//
//  EditViewController.h
//  SQLite
//
//  Created by Henry Yu on 11/1/09.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController {
	
	IBOutlet UITextField *txtField;
	NSString *keyOfTheFieldToEdit;
	NSString *editValue;
	id objectToEdit;
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;

- (IBAction) save_Clicked:(id)sender;
- (IBAction) cancel_Clicked:(id)sender;

@end
