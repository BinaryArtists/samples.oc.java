//
//  ThumbsViewControllerDelegate.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

@class ThumbsViewController;

@protocol ThumbsViewControllerDelegate <NSObject>

- (int)thumbsViewControllerPhotosCount:(ThumbsViewController *)
    thumbsViewController;
- (void)thumbsViewController:(ThumbsViewController *)thumbsViewController
    fetchPhotoAtIndex:(int)index Location:(NSString *)location;
- (void)thumbsViewController:(ThumbsViewController *)thumbsViewController
    selectedPhotoAtIndex:(int)index;

@end
