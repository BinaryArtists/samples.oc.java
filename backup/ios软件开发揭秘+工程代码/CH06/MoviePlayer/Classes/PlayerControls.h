//
//  PlayerControls.h
//  MoviePlayer
//
//  Created by Henry Yu on 3/27/10.
//  Copyright Sevenuc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>


@interface PlayerControls : UIViewController {
	IBOutlet UISlider *playbackSlider;
	IBOutlet UIButton *playPauseButton;
	IBOutlet UIButton *fackbookButton;
	IBOutlet UILabel *statusLabel;
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *chapterLabel;

	MPMoviePlayerController *player;
	NSTimer *controlsTimer;
	BOOL sliding;

}


-(id)initWithPlayer:(MPMoviePlayerController *)player;
-(void)updatePlaybackTime:(NSTimer*)theTimer;
-(IBAction)handlePlayAndPauseButton:(id)sender;
-(IBAction)handleFackbookButton;
-(IBAction)handleShareButton;
-(IBAction)playbackSliderMoved:(UISlider *)sender;
-(IBAction)playbackSliderDone:(UISlider *)sender;
-(void)playerPlaybackStateDidChange:(NSNotification*)notification;
-(void)playerFinishedCallback: (NSNotification*) aNotification;
-(void)handleControlsTimer:(NSTimer *)timer;
-(void)removeControls;
-(void)cancelTimer;

@end
