//
//  LongTextFieldViewController.m
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "LongTextFieldViewController.h"


@implementation LongTextFieldViewController
@synthesize string,isHistory;
@synthesize textView;
@synthesize delegate;

- (void)cancel{
    [[self.delegate navController] popViewControllerAnimated:YES];
}

- (void)save{
	NSString *str =  textView.text;
  	if ([self.delegate respondsToSelector:@selector(takeNewString:)]){
		[self.delegate takeNewString:str];	
	}
	[[self.delegate navController] popViewControllerAnimated:YES];
}


#pragma mark -
- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
	NSUInteger firstRowIndices[] = {0,0};
	NSIndexPath *firstRowPath = [NSIndexPath indexPathWithIndexes:firstRowIndices length:2];
	UITableViewCell *firstCell = [self.tableView cellForRowAtIndexPath:firstRowPath];
	UITextView *firstCellTextField = nil;
	for (UIView *oneView in firstCell.contentView.subviews)
	{
		if ([oneView isMemberOfClass:[UITextView class]]){
			firstCellTextField = (UITextView *)oneView;
		}
	}
		
	if(isHistory){
		firstCellTextField.text = string;

	}else{
		[firstCellTextField becomeFirstResponder];
		
		UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
									   initWithTitle:NSLocalizedString(@"Save", @"changes")
									   style:UIBarButtonItemStylePlain
									   target:self
									   action:@selector(save)];
		self.navigationItem.rightBarButtonItem = saveButton;
		[saveButton release];
	}
	
    
    [super viewWillAppear:animated];
}

- (void)dealloc{
    [string release];
    [textView release];
    [super dealloc];
    
}

#pragma mark Tableview methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *LongTextFieldCellIdentifier = @"LongTextFieldCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LongTextFieldCellIdentifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:LongTextFieldCellIdentifier] autorelease];
		UITextView *theTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, 161.0)];
		//theTextView.scrollEnabled = NO;
		//theTextView.textColor = [UIColor colorWithWhite:1 alpha:1];
		//theTextView.backgroundColor = [UIColor clearColor];
		//theTextView.textAlignment = UITextAlignmentLeft;
		//theTextView.font = [UIFont systemFontOfSize:13];
		
		theTextView.editable = YES;
		theTextView.text = string;
		theTextView.font = [UIFont systemFontOfSize:14.0]; 
		
		if(isHistory){
			theTextView.editable = NO;
			theTextView.userInteractionEnabled = NO;
		}else{						
			[theTextView becomeFirstResponder];			
		}		
		self.textView = theTextView;		
		[[cell contentView] addSubview:theTextView];
		[theTextView release];
    }
	
    // This doesn't work - no matter where I put it. It's almost as if this property is readonly
	if(!isHistory)
       textView.selectedRange = NSMakeRange([string length], 0);;
	    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Nothing for now
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 181.0;
}

@end

