//
//  TouchableView.h
//  MultiTouch
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchableViewDelegate <NSObject>
@optional
- (void)touchDragBegin;
- (void)touchDragEnd;
- (void)touchDragMove;
- (void)touchDragCancel;
@end

@interface TouchableView : UIImageView {
    //CGAffineTransform originalTransform;
    //CFMutableDictionaryRef touchBeginPoints;
	CGPoint firstTouch;
	CGPoint lastTouch;
	id <TouchableViewDelegate> delegate;
}
@property (retain) id <TouchableViewDelegate> delegate;
@end



