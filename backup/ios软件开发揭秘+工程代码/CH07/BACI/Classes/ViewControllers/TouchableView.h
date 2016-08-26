//
//  TouchableView.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

@interface TouchableView : UIView
{
    id target;
    NSDictionary *userInfo;
    SEL touchesBeganSelector;
    SEL touchesMovedSelector;
    SEL touchesEndedSelector;
    SEL touchesCancelledSelector;
    UIView *selectionOverlay;
}

@property (nonatomic, assign) SEL touchesBeganSelector;
@property (nonatomic, assign) SEL touchesMovedSelector;
@property (nonatomic, assign) SEL touchesEndedSelector;
@property (nonatomic, assign) SEL touchesCancelledSelector;

- (id)initWithFrame:(CGRect)frame target:(id)_target
    userInfo:(NSDictionary *)_userInfo;

@end
