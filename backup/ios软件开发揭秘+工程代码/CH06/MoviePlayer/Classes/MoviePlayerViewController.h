//
//  MoviePlayerViewController.h
//  MoviePlayer
//
//  Created by Henry Yu on 3/27/10.
//  Copyright Sevenuc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import "ImageViewWithTime.h"
#import "CommentView.h"
#import "PlayerControls.h"


@interface MoviePlayerViewController : UIViewController {
	UIView *viewForMovie;
	MPMoviePlayerController *player;
	UIScrollView *thumbnailScrollView;	
	int position;
}

@property (nonatomic, retain) IBOutlet UIView *viewForMovie;
@property (nonatomic, retain) MPMoviePlayerController *player;


- (NSURL *)movieURL;
- (void)handleTapFrom:(UITapGestureRecognizer *)recognizer;
- (void)removeView:(NSTimer*)theTimer;


@end

