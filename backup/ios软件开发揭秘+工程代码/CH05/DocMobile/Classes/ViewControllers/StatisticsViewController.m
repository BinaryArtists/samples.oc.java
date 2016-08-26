//
//  StatisticsViewController.m
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import "StatisticsViewController.h"
#import "IndicatorSubviewCell.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "IndicatorDetailViewController.h"

@implementation StatisticsViewController

@synthesize iconList, webservice; 
@synthesize data, myTableView, tmpCell, prevButton, nextButton;

- (void)initIconList{
	
	self.iconList = [[NSMutableDictionary alloc] init];	
    [iconList setValue: @"indicator1.png" forKey: @"OUTOFBOUNDS"];
	[iconList setValue: @"indicator2.png" forKey: @"THREELIMITS_STATEONE"];
	[iconList setValue: @"indicator3.png" forKey: @"THREELIMITS_STATETWO"];
	[iconList setValue: @"indicator4.png" forKey: @"FOURLIMITS_STATEONE"]; 
	[iconList setValue: @"indicator5.png" forKey: @"FOURLIMITS_STATETWO"];
	[iconList setValue: @"indicator6.png" forKey: @"FOURLIMITS_STATETHREE"];
	[iconList setValue: @"indicator7.png" forKey: @"FIVELIMITS_STATEONE"];
	[iconList setValue: @"indicator8.png" forKey: @"FIVELIMITS_STATETWO"];
	[iconList setValue: @"indicator9.png" forKey: @"FIVELIMITS_STATETHREE"];
	[iconList setValue: @"indicator10.png" forKey: @"FIVELIMITS_STATEFOUR"];
	[iconList setValue: @"indicator11.png" forKey: @"SIXLIMITS_STATEONE"];
	[iconList setValue: @"indicator12.png" forKey: @"SIXLIMITS_STATETWO"];
	[iconList setValue: @"indicator13.png" forKey: @"SIXLIMITS_STATETHREE"];
	[iconList setValue: @"indicator14.png" forKey: @"SIXLIMITS_STATEFOUR"];
	[iconList setValue: @"indicator15.png" forKey: @"SIXLIMITS_STATEFIVE"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//Todo
	prevButton.enabled = FALSE;
	nextButton.enabled = FALSE;
	
    self.data = [[NSMutableArray alloc] init];	  
 	[self initIconList];
	
	AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *hashCode = appDelegate.hashCode; 	
	if(webservice == nil){
		webservice = [WebDocWebService instance];	
		webservice.delegate = self;		
	}	
	[webservice wsListIndicators:hashCode];
	
	//start animating...
	activityIndicator = [[UIActivityIndicatorView alloc] 
						 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);		
	activityIndicator.center = self.view.center;
	[self.view addSubview: activityIndicator];
	[activityIndicator startAnimating];		
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return YES;
        default:
            return NO;
    }
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IndicatorCellIdentifier";
    
    IndicatorCell *cell = (IndicatorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"IndicatorSubviewCell" owner:self options:nil];
        cell = tmpCell;
        self.tmpCell = nil;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	    
    cell.useDarkBackground = FALSE; //(indexPath.row % 2 == 0);

	// Configure the data for the cell.
	
    NSMutableDictionary *dataItem = [data objectAtIndex:indexPath.row];
    cell.icon = [UIImage imageNamed:[dataItem objectForKey:@"Icon"]];
    cell.Name = [dataItem objectForKey:@"Name"];
    cell.Value = [dataItem objectForKey:@"Value"];
	
	NSLog(@"***cellForRowAtIndexPath, Icon:%@",[dataItem objectForKey:@"Icon"]);
	NSLog(@"***cellForRowAtIndexPath, Icon:%@",cell.icon);
	
	[dataItem setObject:cell forKey:@"cell"];
   	
	UIImage *image = [UIImage imageNamed:@"detail.png"];
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	button.frame = frame;	// match the button's size with the image size
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	[button addTarget:self action:@selector(indicatorDetailTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];
	cell.accessoryView = button;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.detailTextLabel.text = [dataItem objectForKey:@"Name"];
	cell.detailTextLabel.numberOfLines = 2;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc{
    [data release];
	[myTableView release];
	[activityIndicator release];
    [super dealloc];
}


- (void)indicatorDetailTapped:(id)sender event:(id)event{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.myTableView];
	NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
	{
		[self tableView: self.myTableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{	
	if(data != nil){	
		NSMutableDictionary *dataItem = [data objectAtIndex:indexPath.row];	
		
		UITableViewCell *cell = [dataItem objectForKey:@"cell"];
		UIButton *button = (UIButton *)cell.accessoryView;		
		UIImage *newImage = [UIImage imageNamed:@"detail.png"];
		[button setBackgroundImage:newImage forState:UIControlStateNormal];
				
		// load the clicked cell
		IndicatorDetailViewController *detailView = [[IndicatorDetailViewController alloc] initWithNibName:@"IndicatorDetailViewController" bundle:nil];
		// show the view
		detailView.title = [dataItem objectForKey:@"Description"];
		detailView.indicatorId = [dataItem objectForKey:@"Id"];
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
		[backButton release];
		[self.navigationController pushViewController:detailView animated:YES];	
	}	
}

- (void)removeIndicator{
	if(activityIndicator != nil){
		[activityIndicator stopAnimating];
		[activityIndicator removeFromSuperview];
		[activityIndicator release];
		activityIndicator = nil;	
	}
}

- (void) didOperationCompleted:(NSDictionary *)dict{
	NSString *operation = [dict objectForKey:@"recordHead"];
	NSMutableArray *recordStack = [dict objectForKey:@"Data"];
	NSLog(@"***recordDict:%@",recordStack);
	if ([operation isEqualToString:@"Indicator"]) {
	
		if([recordStack count]){	

			NSInteger i = 0, nResult = [recordStack count];	
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity: nResult];
			for(i = 0; i < nResult; i++){

				NSDictionary *recordDict = [[recordStack objectAtIndex:i] objectForKey:@"Indicator"];
				//NSLog(@"***recordDict:%@",recordDict);
				NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
				NSDictionary *IdIndicator = [recordDict objectForKey:@"IdIndicator"];
				NSDictionary *Title = [recordDict objectForKey:@"Title"];
				NSDictionary *Description = [recordDict objectForKey:@"Description"];
				NSDictionary *isPercent = [recordDict objectForKey:@"isPercent"]; 
				NSString *isPercentValue = [isPercent objectForKey:@"value"]; 
			
				NSDictionary *Value = [recordDict objectForKey:@"Value"];	
				NSString *valueString = @"";					
				if ([isPercentValue isEqualToString:@"true"]) {
					NSString *valueString0 = [Value objectForKey:@"value"];					 
					valueString = [NSString stringWithFormat:@"%.2f%%",[valueString0 floatValue]*100];
				}else{
					valueString = [Value objectForKey:@"value"];
				}
				//NSString *line = [NSString stringWithFormat:@"%@-%@",
				             // [Title objectForKey:@"value"],				              
				            //  [Description objectForKey:@"value"]];
				
				NSDictionary *ActualState = [recordDict objectForKey:@"ActualState"];	
				[tempDict setValue: [IdIndicator objectForKey:@"value"] forKey: @"Id"];
				[tempDict setValue: [Title objectForKey:@"value"] forKey: @"Name"];	
				[tempDict setValue: [Description objectForKey:@"value"] forKey: @"Description"];
				[tempDict setValue: [ActualState objectForKey:@"value"] forKey: @"State"];
				[tempDict setValue: valueString forKey: @"Value"];
				
				NSString *iconName = [iconList objectForKey:[ActualState objectForKey:@"value"]];
				NSLog(@"***iconName:%@",iconName);
				[tempDict setValue: iconName forKey: @"Icon"];
				[tempArray addObject:tempDict];	
				[tempDict release];
			}
			data = [tempArray copy];
			[tempArray release];
			
			[myTableView reloadData];
		}else{
			//AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];	
			//[appDelegate messageBox:@"ListIndicator Operation failure" Error:nil];
		}
	}
	
	[self removeIndicator];		
	
}	

- (void)didOperationError:(NSError*)error{

	UIAlertView *errorAlert = [[UIAlertView alloc]
							   initWithTitle: [error localizedDescription]
							   message: [error localizedFailureReason]
							   delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
	
	[self removeIndicator];	
	
	//Todo
	prevButton.enabled = FALSE;
	nextButton.enabled = FALSE;
	
}


- (void)viewDidUnload{
	self.myTableView = nil;
	self.data = nil;
}

- (void)previousAction:(id)sender{
	//TODO 
}

- (void)nextAction:(id)sender{
	//TODO
}

@end

