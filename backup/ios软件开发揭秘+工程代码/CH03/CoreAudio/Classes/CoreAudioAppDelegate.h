//
//  CoreAudioAppDelegate.h
//  CoreAudio
//
//  Created by Henry Yu on 09-02-01.
//  Copyright 2009 sevenuc.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class SoundEffect;
@interface CoreAudioAppDelegate : NSObject
       <UIApplicationDelegate,AVAudioPlayerDelegate> {
    UIWindow *window;
	SystemSoundID soundID;
	AVAudioPlayer *player;
	
	SoundEffect *erasingSound;
	SoundEffect *selectSound;	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) AVAudioPlayer *player;

- (IBAction)playCaf:(id)sender;
- (IBAction)playMp3:(id)sender;

@end

