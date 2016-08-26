//
//  SlideshowViewControllerDelegate.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

@class SlideshowViewController;

@protocol SlideshowViewControllerDelegate <NSObject>

- (int)slideshowViewControllerPhotosCount:(SlideshowViewController *)slideshowViewController ControllerType:(int)t;
- (void)slideshowViewController:(SlideshowViewController *)
slideshowViewController fetchPhotoAtIndex:(int)index Location:(NSString *)location Type:(int)t Page:(int)p;

@end
