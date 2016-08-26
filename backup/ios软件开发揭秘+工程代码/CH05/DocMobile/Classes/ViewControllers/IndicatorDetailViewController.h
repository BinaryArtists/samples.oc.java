//
//  IndicatorDetailViewController.h
//  WebDoc
//
//  Created by Henry Yu on 09-10-26.
//  Copyright Sevenuc.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface IndicatorDetailViewController : UIViewController {
      WebDocWebService *webservice;
	  UIImageView* imageView;
	  NSString *indicatorId;
	  NSData *imgData;
	  UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic, retain) NSString *indicatorId;
@property(nonatomic, retain) WebDocWebService *webservice;

- (void)displayImage;
@end
