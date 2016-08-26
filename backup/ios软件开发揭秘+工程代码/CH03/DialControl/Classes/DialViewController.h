//
//  DialViewController.h
//  DialControl
//
//  Created by Henry Yu on 10-11-27.
//  Copyright 2010 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDialView.h"

@interface DialViewController : UIViewController< UIDialViewDelegate> {
   UIDialView *dialView;
   UILabel *myLabel;
}

@property (nonatomic, retain) NSMutableArray *records;


@end
