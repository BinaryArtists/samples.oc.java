//
//  CoreAudioAppDelegate.m
//  CoreAudio
//
//  Created by Henry Yu on 09-02-01.
//  Copyright 2009 sevenuc.com. All rights reserved.
//

#import "CoreAudioAppDelegate.h"
#import "SoundEffect.h"

@implementation CoreAudioAppDelegate

@synthesize window;
@synthesize player;

#pragma mark -
#pragma mark Application lifecycle
- (IBAction) playCaf:(id)sender{
	[erasingSound play];
	[selectSound play];	
}

- (void)pause {
	[player pause];	
	AudioSessionSetActive(false);
}

- (void)play {	
	[player play];	
	
	UInt32 category = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (category), &category);
    AudioSessionSetActive (true);	
}

- (IBAction)playMp3:(id)sender{
	if (!player) {
		NSError *error = nil;
		NSString *path = [[NSBundle mainBundle] pathForResource:@"dream" ofType:@"mp3"];
		NSURL *url = [NSURL fileURLWithPath:path];
		
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
		player.delegate = self;
	}
	
	if (player.playing) {
		[self pause];
	} else if (player) {
		[self play];
	}
	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	// Load the sounds
	NSBundle *mainBundle = [NSBundle mainBundle];	
	//NSString *caf1path = [NSString stringWithFormat:@"file://%@",[mainBundle pathForResource:@"Erase" ofType:@"caf"]];
	//caf1path = [caf1path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	
	erasingSound = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Erase" ofType:@"caf"]];
	selectSound =  [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Select" ofType:@"caf"]];
		
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[selectSound release];
	[erasingSound release];
    [window release];
    [super dealloc];
}


@end
