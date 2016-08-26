//
//  ThumbsView.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

@class ThumbsViewController;
@class VLayoutView;

@interface ThumbsView : UIScrollView
{
    ThumbsViewController *controller;
    VLayoutView *mainLayout;
    NSMutableArray *photoContainers; 
}

- (id)initWithFrame:(CGRect)frame controller:(ThumbsViewController *)c;

- (void)setNumberOfPhotos:(int)n;
- (void)setPhoto:(UIImage *)photo atIndex:(int)index;

- (UIView *)loadingIndicatorView;
- (void)thumbTapped:(NSDictionary *)userInfo;

@end
