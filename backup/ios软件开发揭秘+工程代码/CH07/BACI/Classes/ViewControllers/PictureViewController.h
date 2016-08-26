//
//  PictureViewController.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PictureViewController : UIViewController {
    id timer;
	
	BOOL isInitFromPortraitMode;
	NSString *videoFile;
	UIActivityIndicatorView *activityIndicator;
}

- (id)initWithVideoFile:(NSString*)_filename;
- (UIImage*)rotate:(UIImage*)src direction:(UIImageOrientation)orientation;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
- (void)backToBigPicture:(id)sender;
- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation;
- (void)setupPortraitMode;
- (void)getFullScreenImage;
- (void)asyncPhotoRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo;
- (void)asyncPhotoRequestFailed:(NSError *)error
					   userInfo:(NSDictionary *)userInfo;
- (BOOL)isReachabilitable;
- (void)showReachabilityView:(BOOL)isConnectable;

@end

