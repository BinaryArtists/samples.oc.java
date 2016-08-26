//
//  ListViewController.h
//  Zoo
//
//  Created by Henry Yu on 10-11-09.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Category;
@interface ListViewController : UIViewController
    <NSFetchedResultsControllerDelegate,
      UITableViewDelegate,
      UITableViewDataSource> {
	UIView *mainView;
	UITableView	*theTableView;	
	int iCurrentCategory;
@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property int iCurrentCategory;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (void)initAnimals;
- (BOOL)doAddAnimal:(Category *)category Name:(NSString *)name Image:(NSString *)imageName;
- (UIImage *)CreateThumbnail:(UIImage *)selectedImage;

@end
