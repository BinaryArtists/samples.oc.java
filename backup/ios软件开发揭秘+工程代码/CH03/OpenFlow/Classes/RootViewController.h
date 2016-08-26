//
//  RootViewController.h
//  HappyPinting
//
//  Created by Henry Yu on 12/7/10.
//  Copyright 2009 Sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFOpenFlowView.h"

#define COVERFLOWHEIGHT 300
#define COVERFLOWIMAGESIZE CGSizeMake(150, 200)

@interface RootViewController : UIViewController 
      < AFOpenFlowViewDataSource, AFOpenFlowViewDelegate> {
		   
	int iCurrentCategory;
	int iCurrentSelection;	   
		   
	//NSOperationQueue *loadImagesOperationQueue;
	NSMutableArray *imageArray;	
	
}

@property int iCurrentCategory;
@property int iCurrentSelection;

- (void)initAnimals;
- (BOOL)doAddAnimal: (NSString *)name Image:(NSString *)imageName;
- (void)showPaintingViewController;
- (void)refreshCoverFlow;
- (void)setDataAvailable:(BOOL)available;

@end


