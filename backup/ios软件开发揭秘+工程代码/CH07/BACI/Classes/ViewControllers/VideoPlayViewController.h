//
//  VideoPlay_iPadViewController.h
//  BACI
//
//  Created by Henry Yu on 14/07/10.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayViewController : UIViewController {
    id timer;
	MPMoviePlayerController *videoPlayer;
	NSURL *videoURL;
	NSString *videoFile;
	UIActivityIndicatorView *activityIndicator;
}

- (id)initWithVideoFile:(NSString*)_filename;
- (void)playMovie;
- (void)backToPlayList:(id)sender;
- (void)adjustViewsForOrientation:(UIInterfaceOrientation)orientation;
- (void)setupPortraitMode;
- (void)fetchMovieFile;
- (void)asyncPhotoRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo;
- (void)asyncPhotoRequestFailed:(NSError *)error
					   userInfo:(NSDictionary *)userInfo;
- (void)createToolbar;
- (BOOL)isReachabilitable;
- (void)showReachabilityView:(BOOL)isConnectable;

@end

