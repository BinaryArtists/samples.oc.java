//
// File: DocumentDetailViewController.h
// Abstract: The view controller for document detail.
// Version: 1.0
// 
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved. 
// All Rights Reserved.

#import <UIKit/UIKit.h>
#import "DirectoryViewController.h"
#import "Document.h"

@protocol DocumentDetailViewControllerDelegate <NSObject>
@required
- (void)updateWorkflow:(NSString*)str;
@end

@interface DocumentDetailViewController : UIViewController <UINavigationControllerDelegate> {
	UIColor *defaultTintColor;
	UIImage    *rowImage;
	NSString   *docmentId;

	Document *document;
    UISegmentedControl    * segmentedControl;
    UIViewController      * activeViewController;
    NSArray               * segmentedViewControllers;
	UIToolbar *toolbar;
	UIBarButtonItem *infoButton;	
	NSInteger selectedSegmentTab;
	DirectoryViewController *directoryViewController;
	id<DocumentDetailViewControllerDelegate>  delegate;
}

@property (nonatomic, retain, readonly) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain, readonly) UIViewController            *activeViewController;
@property (nonatomic, retain, readonly) NSArray                     *segmentedViewControllers;
@property (nonatomic, retain) Document  *document;
@property (nonatomic, retain) NSString  *docmentId;
@property (nonatomic, retain) UIImage *rowImage;
@property (nonatomic, retain) DirectoryViewController *directoryViewController;
@property (nonatomic, assign)  id <DocumentDetailViewControllerDelegate> delegate;

- (void)preLoadData;
- (void)viewWillAppearDetail:(BOOL)animated; 
- (void)setNavigatinBarStyle:(NSInteger)style;

@end
