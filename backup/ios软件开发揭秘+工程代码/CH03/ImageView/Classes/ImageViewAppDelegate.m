//
//  ImageViewAppDelegate.m
//  ImageView
//
//  Created by Henry Yu on 10-04-11.
//  Copyright 2011 Sevensoft Information Technology Ltd.(http://www.sevenuc.com)
//  All rights reserved.
//

#import "ImageViewAppDelegate.h"

@implementation ImageViewAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    [window makeKeyAndVisible];
	
	
	//显示资源图片:
	UIImage *photo = [UIImage imageNamed:@"smile.jpg"]; 
	UIImageView *tempView = [[UIImageView alloc] initWithImage:photo];
	tempView.center = CGPointMake(window.center.x,window.center.y-100);
	[window addSubview:tempView];
	[tempView release];

	
	//显示本地图片:
	NSString *imagePath = [NSString stringWithFormat:@"file://%@/ImageView.app/images/smile2.jpg",NSHomeDirectory()]; 
	NSLog(@"imagePath:%@",imagePath);
	NSString *escapedPath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"]; 
	NSURL *url = [NSURL URLWithString: escapedPath]; 
	UIImage *image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];	
	UIImageView *picture1 = [[UIImageView alloc] initWithImage:image1];
	tempView.center = CGPointMake(window.center.x+50,window.center.y+100);
	[window addSubview:picture1];
	[picture1 release];
	
	
	/*
	//显示网络图片,使用 NSURL 直接下载
	NSURL *url2 = [NSURL URLWithString: @"http://www.sevenuc.com/image/xn4.png"]; 
	UIImage *image2 = [UIImage imageWithData: [NSData dataWithContentsOfURL:url2]];
	UIImageView *picture2 = [[UIImageView alloc] initWithImage:image2];
	[window addSubview:picture2];
	[picture2 release];
	*/
					  
	//显示网络图片, 使用其它方法(如 NSURLConnection,Web Service等)先下载图片数据,再使用该数据创建UIImage对象:				  
    //NSData *data = ... 
	//UIImage *image = [UIImage imageWithData:data]; 
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	//[imageView release];	
												 
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
    [window release];
    [super dealloc];
}


@end
