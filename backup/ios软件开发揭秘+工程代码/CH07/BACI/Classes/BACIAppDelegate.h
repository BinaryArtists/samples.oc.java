//
//  BACIAppDelegate.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPhotoGalleryDelegate.h"
#import "SplashViewController.h"
#import "LanguageViewController.h"

@class IPhotoGallery;

@interface BACIAppDelegate : NSObject <UIApplicationDelegate,
IPhotoGalleryDelegate>
{
    UIWindow *window;
	NSDictionary *defaultsDict;
	NSDictionary *localStringDict;
	LanguageViewController *languageViewController;
	SplashViewController *splashViewController;	
    IPhotoGallery *photoGallery;

	BOOL isInitToolBar;	
	int mainMenu;
	int currentSeries;	
	int savedCurrentSeriesId;
	int savedSeriesDetailIndex;
	NSString *baseDirectory;
	NSString *baseURLDirectory;
	BOOL adjustToolBar;
	BOOL adjustToolBar2;
	NSString *currentLanguage;
	BOOL firstSeriesDetail;
	BOOL firstThumbsView;
	BOOL firstSearch;
}

@property int  mainMenu;
@property int  currentSeries;
@property int  savedSeriesDetailIndex;
@property BOOL isInitToolBar;
@property BOOL adjustToolBar;
@property BOOL adjustToolBar2;
@property (nonatomic, retain) NSString *currentLanguage;
@property (nonatomic, retain) IBOutlet UIWindow *window;
- (IPhotoGallery *)getPhotoGallery;

- (void)showLanguageView;
- (void)showMainmenuView;
- (void)showThumbs:(int)index;
- (void)showSeriesView:(int)index;
- (void)showSeriesDetailView:(int)index fromType:(int)t;
- (NSString *)getInfoTextbyIndex:(int)index;
- (void)showBigPictureView:(int)index fromType:(int)t;
- (NSArray *)getCurrentSeriesIds;
- (int)getCurrentSeriesStartId:(int)s;
- (NSString*)getCurrentSeriesDirectory;
- (NSString *)getSeriesName:(int)menu;
- (UIColor *)getColorByIndex:(int)index;
- (NSString *)getSeriesNameByIndex:(int)index;
- (NSString *)getBigPictureNamebyIndex:(int)index Selection:(BOOL)back;
- (NSString *)getMovieNamebyIndex:(int)index;
- (UIImage *)getMovieThumbImage:(int)index;
- (void)asyncPhotoRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo;
- (void)asyncPhotoRequestFailed:(NSError *)error
					   userInfo:(NSDictionary *)userInfo;
- (void)doSearch:(NSString*)text;
- (BOOL)doSearchHelper:(int)mainMenuId itemId:(int)item;

- (void)parseConfiguration;
- (BOOL)checkLimit:(NSString *)str;
- (UIImage *)getLocalImageAtIndex:(int)index Location:(NSString *)location;
- (void)getMovieThumbImage2:(int)index Page:(int)p;
- (UIImage *)getRemoteImageAtIndex:(int)index Location:(NSString *)location Type:(NSString *)t Page:(int)p;
- (void)fetchLocalPhotoAtIndex:(int)index Location:(NSString *)location Type:(int)t Page:(int)p;
- (void)messageBox:(NSString*)msg;
- (NSString *)getLocalTextString:(NSString *)text;
- (CGFloat)textWidthByFontSize:(NSString *)text FontSize:(int)fontSize;
- (NSString *)getBaseUrlIPAddress;

@end

