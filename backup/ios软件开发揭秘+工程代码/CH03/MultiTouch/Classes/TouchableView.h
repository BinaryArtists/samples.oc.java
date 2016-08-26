//
//  TouchableView.h
//  MultiTouch
//
//  Created by Henry Yu on 10-11-17.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TouchableView : UIImageView {
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
}

@end
