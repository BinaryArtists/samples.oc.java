//
//  BACIAppDelegate.m
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//


#import "BACIAppDelegate.h"
#import "IPhotoGallery.h"
#import "AsyncNet.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"

#import "BACIAppDelegate.h"

@implementation BACIAppDelegate
@synthesize window;
@synthesize currentLanguage;
@synthesize mainMenu,currentSeries,savedSeriesDetailIndex;
@synthesize isInitToolBar,adjustToolBar,adjustToolBar2;

- (NSString *)getLocalTextString:(NSString *)text{
	if(localStringDict == nil) return text;
	if([currentLanguage isEqualToString:@"L1"]) return text;
		
	NSString* result = [localStringDict objectForKey:text];
	NSLog(@"getLocalTextString,result:%@",result);
	if(result == nil) return text;	
	return result;
}

-(void)parseConfiguration{
	
	NSString *filePath = @"/Users/henryyu/Desktop/BACI/baci.plist";
#if RELEAE_DEVICE	
	filePath = [NSString stringWithFormat:@"%@/baci.plist",baseDirectory];
#endif	
	
	defaultsDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
	[defaultsDict retain];	
		
	//
	currentLanguage = [defaultsDict objectForKey:@"Language"];
	NSLog(@"currentLanguage:%@",currentLanguage);
	NSString *langPath = [NSString stringWithFormat:@"%@/LocalizedString.plist",baseDirectory];
	localStringDict = [NSDictionary dictionaryWithContentsOfFile:langPath];
	[localStringDict retain];
		
}

-(BOOL)checkLimit:(NSString *)secretString{
		
	return TRUE;
	
}

-(void)messageBox:(NSString*)msg{
	UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"B.A.C.I" 
				 message:msg 
				delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

- (NSString *)getBaseUrlIPAddress{
	
	NSRange iCheck = [baseURLDirectory rangeOfString :@"http://"];
	if (iCheck.length > 0){		
	}else{
		return @"";
	}
	NSString *tmpStr = [baseURLDirectory substringFromIndex:7];
	NSRange iStart = [tmpStr rangeOfString :@"/"];
	NSString *ip = @"";
	if (iStart.length > 0){	
	    ip = [tmpStr substringToIndex:iStart.location-1];
	}else{
		return tmpStr;
	}	
	return ip;	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	isInitToolBar = TRUE;
	adjustToolBar = FALSE;
	adjustToolBar2 = FALSE;
	firstSeriesDetail  = TRUE;
	firstThumbsView = TRUE;
	firstSearch = TRUE;
	mainMenu = 0;
	currentSeries = 0;
	savedCurrentSeriesId = 0;
	baseDirectory = @"/Applications/BACI.app"; 
		
	NSFileManager *fileManager = [NSFileManager defaultManager];

#if	IPAD_322_RELEASE
	NSString *escapedPath = [[NSBundle mainBundle] pathForResource:@"arrowLeft" ofType:@"png"];
	NSArray *strings = [escapedPath componentsSeparatedByString: @"/"];
	NSString *documentFilename0  = [strings objectAtIndex:[strings count]-1];
	NSRange iStart = [escapedPath rangeOfString :documentFilename0];
	baseDirectory = [escapedPath substringToIndex:iStart.location-1];	
#endif
	
#if DEVELOPER_DEBUG	
	baseDirectory = @"/Users/henryyu/Desktop/BACI";
#endif
			

#if INIT_CHECK_IMAGE	
	NSString *checkFile = [NSString stringWithFormat:@"%@/Media/LINGERIE/001_F.jpg",baseDirectory];
	
	BOOL isExists = [fileManager fileExistsAtPath:checkFile];
	if(!isExists){	
		NSString *tellme = [NSString stringWithFormat:@"check resource file\n%@ cannot found!",checkFile];
	    [self messageBox:tellme];
		return FALSE;
	} 
	
	NSString *imagePath = [NSString stringWithFormat:@"file://%@",checkFile];
	NSString *escapedPath2 = [imagePath stringByReplacingOccurrencesOfString:@" " 
																  withString:@"%20"];
	NSURL *url = [NSURL URLWithString:escapedPath2];
	UIImage *photo = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
	if(photo == nil ){
		NSString *tellme = [NSString stringWithFormat:@"check resource file\n%@ cannot create image!",imagePath];
	    [self messageBox:tellme];
		return FALSE;
	}
 
#endif
	
	NSString *configfile = @"/Users/henryyu/Desktop/BACI/baci.plist";
#if RELEAE_DEVICE	
	configfile = [NSString stringWithFormat:@"%@/baci.plist",baseDirectory];
#endif
		
	BOOL bIsExists = [fileManager fileExistsAtPath:configfile];
	if(!bIsExists){
		NSString *msg = [NSString stringWithFormat:@"%@ not exists!",configfile];
		[self messageBox:msg];		
		return FALSE;
	}	
	
	[self parseConfiguration];
	
#if	NETWORK_SUPPORT	
	baseURLDirectory = [defaultsDict objectForKey:@"BaseURL"];
	if(baseURLDirectory == nil){		
		NSString *msg = [NSString stringWithFormat:@"The server url not wrong configuration!"];
		[self messageBox:msg];
		return FALSE;
	}
#endif
	
	[baseDirectory retain];	
	
	NSLog(@"baseDirectory ==>%@",baseDirectory);
	NSLog(@"configfile ==>%@",configfile);
	
	NSString *secretString = [defaultsDict objectForKey:@"CFBundleSignature"];
	if(secretString == nil){
		NSLog(@"secretString == nil");
		return FALSE;
	}
	
	//=====
	BOOL check_success = [self checkLimit:secretString];
	if(!check_success){
		[self messageBox:@"this is a trial version.\n\n please contact us.\n"];		
		return FALSE;
	}
	
	CGRect bounds = [[UIScreen mainScreen] bounds];
	int screenWidth =  bounds.size.width;
	int screenHeight =  bounds.size.height;
	NSLog(@"didFinishLaunchingWithOptions,screenWidth->%d,screenHeight->%d",
		  screenWidth,screenHeight);	
	
	languageViewController = [[LanguageViewController alloc] 
							  initWithNibName:@"LanguageViewController" bundle:nil];
	languageViewController.view.tag = kTagLanguageView;
	
	photoGallery = [[IPhotoGallery alloc] initWithDelegate:self];
	photoGallery.topViewController.title = @"";
	[photoGallery pushViewController:languageViewController animated:YES];
		
	[window addSubview:photoGallery.view];
	[window makeKeyAndVisible];	
	
	return YES;	
}

#pragma mark -
#pragma mark Show Views
-(void)showLanguageView{
		
	if(languageViewController == nil){
		languageViewController = [[LanguageViewController alloc] 
								initWithNibName:@"SplashViewController" bundle:nil];
		languageViewController.view.tag = kTagLanguageView;
	}else{
		BOOL find = [photoGallery findViewControllerByTag:kTagLanguageView];
		if(!find){
			[photoGallery pushViewController:languageViewController animated:YES];
		}		
	}
	//
	if(languageViewController != nil){		
	    languageViewController.adjustToolbar = 1;
	}
	if(splashViewController != nil){		
	    splashViewController.adjustToolbar = 1;
	}
	
}

-(void)showMainmenuView{
		
	NSLog(@"currentLanguage:%@",currentLanguage);
	//--------------------------------------------------------------------------
	if([currentLanguage isEqualToString:@"English"]) {
	}else{
		if(localStringDict != nil){
			[localStringDict release];
			localStringDict = nil;
		}
		
		NSLog(@"currentLanguage:%@",currentLanguage);
		NSString *langPath = [NSString stringWithFormat:@"%@/%@.plist",
							  baseDirectory,currentLanguage];
		localStringDict = [NSDictionary dictionaryWithContentsOfFile:langPath];
		[localStringDict retain];
		NSLog(@"defaultsDict:%@",localStringDict);
	}
	//----------------------------------------------------------------------------
	
	if(splashViewController == nil){
		splashViewController = [[SplashViewController alloc] 
								initWithNibName:@"SplashViewController" bundle:nil];
		splashViewController.view.tag = kTagMainmenuView;
		[photoGallery pushViewController:splashViewController animated:YES];
	}else{
		BOOL find = [photoGallery findViewControllerByTag:kTagMainmenuView];
		if(!find){			
			[photoGallery pushViewController:splashViewController animated:YES];			
		}		
	}
		
}


-(void)showSeriesView:(int)index{
	if(index != 0 && index != 1 && index != 2)
		return;
	BOOL reload = FALSE;
	if(mainMenu != index)
		reload = TRUE;
	//reset series to default.
	if(reload){
		//if(savedCurrentSeriesId >0)
		//   currentSeries = savedCurrentSeriesId;
		//else 
		currentSeries = 0;
	}
	savedCurrentSeriesId = currentSeries;
	
	NSLog(@"showSeriesView:%d %d => %d",mainMenu,index, reload);
	mainMenu = index;	
	photoGallery.view.hidden = NO;
	
	[photoGallery showSeries:index ReLoad:reload];
}

-(void)showSeriesDetailView:(int)index fromType:(int)t{
	photoGallery.view.hidden = NO;
	//currentSeries = index;	
		
	[photoGallery showSeriesDetailView:index fromType:t];
	if(firstSeriesDetail){
		firstSeriesDetail = FALSE;
		[photoGallery showSeriesDetailView:index fromType:t];
	}
	
}

-(void)showBigPictureView:(int)index fromType:(int)t{
	photoGallery.view.hidden = NO;
	[photoGallery showBigPicture:index fromType:t];
	
}

-(void)showThumbs:(int)index{	
	photoGallery.view.hidden = NO;
	
	[photoGallery showThumbView:index];
	if(firstThumbsView){
		firstThumbsView = FALSE;
        [photoGallery showThumbView:index];
	}	
}

-(void)showStartPage{
	photoGallery.view.hidden = YES;
}


- (void)dealloc
{
    [photoGallery release];
	[splashViewController release];
	[defaultsDict release];
    [window release];
    [super dealloc];
}

- (IPhotoGallery *)getPhotoGallery{
	return photoGallery;
}

#pragma mark -
#pragma mark NETWORK API
- (void)asyncPhotoRequestSucceeded:(NSData *)data
						  userInfo:(NSDictionary *)userInfo
{
	if(data == nil) return;
    int index = [[userInfo objectForKey:@"index"] intValue];
	int page = [[userInfo objectForKey:@"page"] intValue];
	NSString *photoType = [userInfo objectForKey:@"type"];	
	NSString *location = [userInfo objectForKey:@"location"];
	
    UIImage *photo = [UIImage imageWithData:data];
    if ([photoType isEqualToString:@"thumb"]){
        [photoGallery fetchedPhotoThumb:photo atIndex:index];
    }else if ([photoType isEqualToString:@"series"]){
        [photoGallery fetchedPhoto:photo atIndex:index atPage:page Location:location];
	}else if ([photoType isEqualToString:@"detail"]){
		[photoGallery fetchedPhoto2:photo atIndex:index atPage:page Location:location];
	}else if ([photoType isEqualToString:@"big"]){
		NSString *location = [userInfo objectForKey:@"location"];
		[photoGallery fetchedPhoto3:photo atIndex:index atPage:page Location:location];		
	}else{
		int t = 0;
		if([photoType isEqualToString:@"bigthumb1"])
			t = 1;
		else if([photoType isEqualToString:@"bigthumb2"])
			t = 2;
		else if([photoType isEqualToString:@"bigthumb3"])
			t = 3;
		else 
			return;
		
		[photoGallery fetchedBigThumb:photo atIndex:index atPage:page type:t];
	}
	
}

- (void)asyncPhotoRequestFailed:(NSError *)error
					   userInfo:(NSDictionary *)userInfo
{
    int index = [[userInfo objectForKey:@"index"] intValue];
	int page = [[userInfo objectForKey:@"page"] intValue];
	NSString *location = [userInfo objectForKey:@"location"];
	NSLog(@"ERROR,asyncPhotoRequestFailed,page:%d index:%d location:%@",page,index,location);
    UIImage *photo = nil; // might set some default photo depicting error
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"thumb"]){
        [photoGallery fetchedPhotoThumb:photo atIndex:index];
    }else if ([[userInfo objectForKey:@"type"] isEqualToString:@"series"]){
        [photoGallery fetchedPhoto:photo atIndex:index atPage:page Location:location];
	}else if ([[userInfo objectForKey:@"type"] isEqualToString:@"detail"]){
        [photoGallery fetchedPhoto2:photo atIndex:index atPage:page Location:location];
	}else if ([[userInfo objectForKey:@"type"] isEqualToString:@"big"]){
		NSString *location = [userInfo objectForKey:@"location"];
		[photoGallery fetchedPhoto3:photo atIndex:index atPage:page Location:location];
	}else{	
		NSLog(@"ERROR,asyncPhotoRequestFailed,type:%@",[userInfo objectForKey:@"type"]);
	}
}

-(NSArray *)getCurrentSeriesIds{
	NSString* menuName = @"";
	if(mainMenu == LINGERIE)
		menuName = @"LINGERIE";
	else if(mainMenu == EYELASHES)
		menuName = @"EYELASHES";
	else if(mainMenu == CATEGORIES)
		menuName = @"CATEGORIES";
	else
		return nil;	
	NSDictionary *dictLINGERIE = [defaultsDict objectForKey:menuName];
	NSString* validSeries = [dictLINGERIE objectForKey:@"ValidSeries"];	
	NSArray *crayon = [validSeries componentsSeparatedByString:@","];
	//NSLog(@"getCurrentSeriesIds,crayon:%@",crayon);
	return crayon;
	
}

-(BOOL)doSearchHelper:(int)mainMenuId itemId:(int)item{
	BOOL find = FALSE;
	NSString* menuName = @"";
	if(mainMenuId == LINGERIE)
		menuName = @"LINGERIE";
	else if(mainMenuId == EYELASHES)
		menuName = @"EYELASHES";
	else if(mainMenuId == CATEGORIES)
		menuName = @"CATEGORIES";
	else
		return FALSE;
	NSDictionary *dictLINGERIE = [defaultsDict objectForKey:menuName];
	NSArray* arraySeries = [dictLINGERIE objectForKey:@"Series"];
	int i, nSeries = [arraySeries count];
	for(i = 0; i<nSeries; i++){
		NSDictionary *dictSeries = [arraySeries objectAtIndex:i];
		NSString* photoStartId = [dictSeries objectForKey:@"PhotoStartId"];
		int startId = [photoStartId intValue];
		NSString* photoNumber = [dictSeries objectForKey:@"PhotoNumber"];
		int number = [photoNumber intValue];
		if(startId <= item && item <= (startId+number)){
			find = TRUE;
			NSString* seriesID = [dictSeries objectForKey:@"SeriesID"];
			int series = [seriesID intValue];
			NSLog(@"doSearchHelper,series:%D startId:%d number:%d",series,startId,number);
			BOOL ResetALL = FALSE;
			if(mainMenuId != mainMenu){
				ResetALL = TRUE;
			}else{
				if(currentSeries != series){
					ResetALL = TRUE;
				}else{
					int offset = item - startId;
					savedSeriesDetailIndex = offset;//idx;		
					[self showBigPictureView:offset fromType:kTagSeriesDetailView];
				}
			}
			if(ResetALL){
				int offset = item - startId;
				[photoGallery resetAllViews];
				[self showSeriesView:mainMenuId];
				currentSeries = series;       
				[self showSeriesDetailView:series fromType:kTagSeriesView];				
				NSLog(@"doSearchHelper,item:%d,offset:%d",item,offset);
				savedSeriesDetailIndex = offset;//item-1;//idx;		
				[self showBigPictureView:offset fromType:kTagSeriesDetailView];					
			}
			break;	
		}
	}
	return find;
}

-(void)doSearch:(NSString*)text{
	if(text == nil) return;
	if([text length] == 0) return;		
	//if ( [text isMatchedByRegex:@"^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"] ) {
        //value = [newText doubleValue];
    //}	
	NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];	
	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
	BOOL valid = [alphaNums isSupersetOfSet:inStringSet];	
	if (!valid) return; 	
	int theId = [text intValue];
	BOOL found = [self doSearchHelper:mainMenu itemId:theId];
	if(!found){
		NSMutableArray *mainArray = [[NSMutableArray alloc] initWithCapacity:2];
		if(mainMenu == LINGERIE){
			[mainArray addObject:[NSNumber numberWithInt:EYELASHES]];
			[mainArray addObject:[NSNumber numberWithInt:CATEGORIES]];
		}else if(mainMenu == EYELASHES){
			[mainArray addObject:[NSNumber numberWithInt:LINGERIE]];
			[mainArray addObject:[NSNumber numberWithInt:CATEGORIES]];
		}else if(mainMenu == CATEGORIES){
			[mainArray addObject:[NSNumber numberWithInt:LINGERIE]];
			[mainArray addObject:[NSNumber numberWithInt:EYELASHES]];
		}else{
			return;
		}		
		for(int i = 0; i < 2; i++){
			NSNumber* indicator = (NSNumber*)[mainArray objectAtIndex:i];
			int value = [indicator intValue];
			found = [self doSearchHelper:value itemId:theId];
			if(found) break;
		}		
	}
	
	if(found && firstSearch){
		firstSearch = FALSE;
		[self doSearch:text];
	}
	
}

-(int)getCurrentSeriesStartId:(int)s{
	//#if RELEAE_DEVICE	
	NSString* menuName = @"";
	if(mainMenu == LINGERIE)
		menuName = @"LINGERIE";
	else if(mainMenu == EYELASHES)
		menuName = @"EYELASHES";
	else if(mainMenu == CATEGORIES)
		menuName = @"CATEGORIES";
	else
		return 0;	
	NSDictionary *dictLINGERIE = [defaultsDict objectForKey:menuName];
	NSArray* arraySeries = [dictLINGERIE objectForKey:@"Series"];
	int i, nSeries = [arraySeries count];
	for(i = 0; i<nSeries; i++){
		NSDictionary *dictSeries = [arraySeries objectAtIndex:i];
		NSString* seriesID = [dictSeries objectForKey:@"SeriesID"];
		if(currentSeries == [seriesID intValue]){
			NSString* photoStartId = [dictSeries objectForKey:@"PhotoStartId"];
			int startId = [photoStartId intValue];
			if(startId == 0)
				startId == 1;			
			return startId;
		}		
	}
	//#endif
	return 0;	
}

#pragma mark IPhotoGalleryDelegate

- (int)iPhotoGalleryPhotosCount:(IPhotoGallery *)iPhotoGallery ControllerType:(int)t
{
    NSString* menuName = @"";
	if(mainMenu == LINGERIE)
		menuName = @"LINGERIE";
	else if(mainMenu == EYELASHES)
		menuName = @"EYELASHES";
	else if(mainMenu == CATEGORIES)
		menuName = @"CATEGORIES";
	else
		return 0;
	
	NSDictionary *dictLINGERIE = [defaultsDict objectForKey:menuName];
	if(t == SLIDESHOW_SERIES){
		NSString* validSeries = [dictLINGERIE objectForKey:@"ValidSeries"];
        NSArray *crayon = [validSeries componentsSeparatedByString:@","];
		int series = [crayon count];
		return series;
	}else if(t == SLIDESHOW_SERIESDETAILS||t == SLIDESHOW_BIGPICTURE
			 ||t == SLIDESHOW_THUMBS){
		NSArray* arraySeries = [dictLINGERIE objectForKey:@"Series"];
		int i, nSeries = [arraySeries count];
		for(i = 0; i<nSeries; i++){
			NSDictionary *dictSeries = [arraySeries objectAtIndex:i];
		    NSString* seriesID = [dictSeries objectForKey:@"SeriesID"];
		    if(currentSeries == [seriesID intValue]){						
				NSString* photoNumber = [dictSeries objectForKey:@"PhotoNumber"];
				int series = [photoNumber intValue];				
				return series;	
			}
		}
    }else{
		return 0;
	}	
	return 0;
}

- (void)iPhotoGallery:(IPhotoGallery *)iPhotoGallery
fetchPhotoThumbAtIndex:(int)index Location:(NSString *)location
{
	UIImage *photo = nil;  
  
	photo = [self getLocalImageAtIndex:index Location:location];
	if(photo == nil ){
		NSLog(@"ERROR,fetchPhotoThumbAtIndex,index:%d %@",index,location);
		return;
	}	
	[photoGallery fetchedPhotoThumb:photo atIndex:index];
	
}

- (void)iPhotoGallery:(IPhotoGallery *)iPhotoGallery
    fetchPhotoAtIndex:(int)index Location:(NSString *)location Type:(int)t Page:(int)p
{

   	[self fetchLocalPhotoAtIndex:index Location:location Type:t Page:p];
	
	
}

-(NSString *)getSeriesName:(int)menu{
	
	return [self getSeriesNameByIndex:currentSeries];	
}

-(NSString *)getSeriesNameByIndex:(int)index{
	NSString* menuName = @"";
	if(mainMenu == LINGERIE)
		menuName = @"LINGERIE";
	else if(mainMenu == EYELASHES)
		menuName = @"EYELASHES";
	else if(mainMenu == CATEGORIES)
		menuName = @"CATEGORIES";
	else
		return @"";
	NSDictionary *dictLINGERIE = [defaultsDict objectForKey:menuName];
	NSArray* arraySeries = [dictLINGERIE objectForKey:@"Series"];
	int i, nSeries = [arraySeries count];
	for(i = 0; i<nSeries; i++){
		NSDictionary *dictSeries = [arraySeries objectAtIndex:i];	
		int idSeries = [[dictSeries objectForKey:@"SeriesID"] intValue];	
		if(idSeries == index){
		    NSString* seriesName = [dictSeries objectForKey:@"SeriesName"];
			return seriesName;
		}
	}	
	
	return @"";
	
}

-(UIColor *)getColorByIndex:(int)index{
	NSString* menuName = @"";
	if(mainMenu == LINGERIE)
		menuName = @"LINGERIE";
	else if(mainMenu == EYELASHES)
		menuName = @"EYELASHES";
	else if(mainMenu == CATEGORIES)
		menuName = @"CATEGORIES";
	else
		return [UIColor cyanColor];
	
	NSDictionary *dictLINGERIE = [defaultsDict objectForKey:menuName];
	NSArray* arraySeries = [dictLINGERIE objectForKey:@"Series"];
	int i, nSeries = [arraySeries count];
	for(i = 0; i<nSeries; i++){
		NSDictionary *dictSeries = [arraySeries objectAtIndex:i];	
		int idSeries = [[dictSeries objectForKey:@"SeriesID"] intValue];	
		if(idSeries == index){
		    NSString* seriesDirectory = [dictSeries objectForKey:@"SeriesDirectory"];
			
			if([seriesDirectory length] == 0){				
				return [UIColor cyanColor];	
			}
			NSArray *strings = [seriesDirectory componentsSeparatedByString: @"/"];
			NSString *icon  = [strings objectAtIndex:[strings count]-1];
			if([icon length] == 0){					
				return [UIColor cyanColor];
			}
			NSString *iconName = [NSString stringWithFormat:@"%@.jpg",icon];
			
			return [UIColor colorWithPatternImage:[UIImage imageNamed:iconName]];			
		}
	}	
	
	return [UIColor cyanColor];		
	
}

-(NSString*)getCurrentSeriesDirectory{
	NSString* menuName = @"";
	if(mainMenu == LINGERIE)
		menuName = @"LINGERIE";
	else if(mainMenu == EYELASHES)
		menuName = @"EYELASHES";
	else if(mainMenu == CATEGORIES)
		menuName = @"CATEGORIES";
	else
		return @"";
	
	int isShowDemo = [[defaultsDict objectForKey:@"ShowDemo"]intValue];
	if(isShowDemo){
		currentSeries = 0;
	}
	
	NSString* seriesDirectory = @"";
	NSDictionary *dictLINGERIE = [defaultsDict objectForKey:menuName];
	NSArray* arraySeries = [dictLINGERIE objectForKey:@"Series"];
	int i, nSeries = [arraySeries count];
	for(i = 0; i<nSeries; i++){
		NSDictionary *dictSeries = [arraySeries objectAtIndex:i];	
		int idSeries = [[dictSeries objectForKey:@"SeriesID"] intValue];	
		if(idSeries == currentSeries){
		    seriesDirectory = [dictSeries objectForKey:@"SeriesDirectory"];
			break;
		}
	}
	return seriesDirectory;
	
}

-(NSString *)getInfoTextbyIndex:(int)index{
	

	NSString *fixPath = [NSString stringWithFormat:@"/%@",baseDirectory];
	
	NSString* seriesDirectory = [self getCurrentSeriesDirectory];
	if([seriesDirectory length] == 0)
		return @"";
	
	
	int idx = index;//+1;
	int startId = [self getCurrentSeriesStartId:0];
	idx += startId;
	NSString *infoTextPath = [NSString stringWithFormat:@"%@%@/Info/%03d.txt",fixPath,seriesDirectory,idx];
	NSLog(@"infoTextPath: %@", infoTextPath);	

	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isExists = [fileManager fileExistsAtPath:infoTextPath];
	if(isExists){
		NSString *filePath2 = [NSString stringWithFormat:@"file://%@",infoTextPath];
		NSString *escapedPath = [filePath2 stringByReplacingOccurrencesOfString:@" " 
																	 withString:@"%20"];
		
		NSURL *url = [NSURL URLWithString: escapedPath];
		NSData *imgData = [NSData dataWithContentsOfURL:url];
		NSString *infoString = [[NSString alloc] initWithData:imgData encoding:NSUTF8StringEncoding];
		
		return infoString;
	}else{
		return @"";
	}	

	
}


-(void)getMovieThumbImage2:(int)index Page:(int)p{
		
	NSString *fixPath = [NSString stringWithFormat:@"%@",baseDirectory];	
	NSString* seriesDirectory = [self getCurrentSeriesDirectory];
	if([seriesDirectory length] == 0)
		return;	

	int idx = index;//+1;
//	int startId = [self getCurrentSeriesStartId:0];
//	idx += startId;
	NSString *picturePath = [NSString stringWithFormat:@"%@%@/Movie/JPG/%03d.jpg",fixPath,seriesDirectory,idx];
	NSLog(@"%d,getMovieThumbImage2: %@", index,picturePath);
		
	NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]
									 initWithCapacity:3];
	[userInfo setObject:[NSNumber numberWithInt:index] forKey:@"index"];
	[userInfo setObject:@"bigthumb3" forKey:@"type"];
	[userInfo setObject:[NSNumber numberWithInt:p] forKey:@"page"];
	
	[[AsyncNet instance]
	 addRequestForUrl:picturePath
	 successTarget:self
	 successAction:@selector(asyncPhotoRequestSucceeded:userInfo:)
	 failureTarget:self
	 failureAction:@selector(asyncPhotoRequestFailed:userInfo:)
	 userInfo:userInfo];
	[userInfo release];	
	
}

-(UIImage *)getMovieThumbImage:(int)index{
		
	NSString *fixPath = [NSString stringWithFormat:@"file://%@",baseDirectory];

	NSString* seriesDirectory = [self getCurrentSeriesDirectory];
	if([seriesDirectory length] == 0)
		return nil;
	
	
	int idx = index;//+1;
	int startId = [self getCurrentSeriesStartId:0];
	idx += startId;
	NSString *picturePath = [NSString stringWithFormat:@"%@%@/Movie/JPG/%03d.jpg",fixPath,seriesDirectory,idx];
	
	NSString* tempFile = [picturePath substringFromIndex:7];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isExists = [fileManager fileExistsAtPath:tempFile];
	if(!isExists){
		return nil;
	}
	NSString *escapedPath = [picturePath stringByReplacingOccurrencesOfString:@" " 
																 withString:@"%20"];
	NSURL *url = [NSURL URLWithString: escapedPath];
	UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
	return image;
	
}

-(NSString *)getBigPictureNamebyIndex:(int)index Selection:(BOOL)back{
	
#if	NETWORK_SUPPORT	
	NSString *fixPath = [NSString stringWithFormat:@"%@",baseURLDirectory];
#else
	NSString *fixPath = [NSString stringWithFormat:@"file://%@",baseDirectory];
#endif
		
	NSString* seriesDirectory = [self getCurrentSeriesDirectory];
	if([seriesDirectory length] == 0)
		return @"";
	
	int idx = index;//+1;
	int startId = [self getCurrentSeriesStartId:0];
	idx += startId;
	NSString *picturePath = [NSString stringWithFormat:@"%@%@/Big/%03d",fixPath,seriesDirectory,idx];
    NSString* filename;
	filename = [[NSString alloc] initWithFormat:@"%@%@",picturePath,back?@"_B.jpg":@"_F.jpg"];
	
	return filename;
	
}

-(NSString *)getMovieNamebyIndex:(int)index{

#if	NETWORK_SUPPORT		
	NSString *fixPath = [NSString stringWithFormat:@"%@",baseURLDirectory];
#else
	NSString *fixPath = [NSString stringWithFormat:@"file://%@",baseDirectory];
#endif
	
	NSString* seriesDirectory = [self getCurrentSeriesDirectory];
	if([seriesDirectory length] == 0)
		return @"";	
	
#if OPTIMAZE_PAGING	
	int idx = index;
#else
	int idx = index+1;
	int startId = [self getCurrentSeriesStartId:0];
	idx += startId;
#endif	
	NSString *moviePath = [NSString stringWithFormat:@"%@%@/Movie/MP4/%03d.mp4",fixPath,seriesDirectory,idx];
	
	return moviePath;
	
}

- (UIImage *)getRemoteImageAtIndex:(int)index Location:(NSString *)location Type:(NSString *)t Page:(int)p{
	if(location == nil || [location length] == 0)
		return nil;

#if NETWORK_SUPPORT_MOVIE_ONLY	
	return [self getLocalImageAtIndex:index Location:location];
#else	
	NSString *fixPath = [NSString stringWithFormat:@"%@",baseDirectory];
	NSString* seriesDirectory = [self getCurrentSeriesDirectory];
	
	if([seriesDirectory length] == 0)
		return nil;
	
	NSString *imagePath = [NSString stringWithFormat:@"%@%@/%@",fixPath,seriesDirectory,location];
	
	NSArray *strings = [location componentsSeparatedByString: @"/"];
	
	if(1 == [strings count]){
		NSString* menuName = @"";
		if(mainMenu == LINGERIE)
			menuName = @"LINGERIE";
		else if(mainMenu == EYELASHES)
			menuName = @"EYELASHES";
		else if(mainMenu == CATEGORIES)
			menuName = @"CATEGORIES";
		else
			return nil;	
		imagePath = [NSString stringWithFormat:@"%@/Media/%@/%@",fixPath,menuName,location];
	}
	
	NSLog(@"[tmpdata imgPath]: %@", imagePath);
		
	NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]
									 initWithCapacity:4];
	[userInfo setObject:[NSNumber numberWithInt:index] forKey:@"index"];
	[userInfo setObject:t forKey:@"type"];
	[userInfo setObject:[NSNumber numberWithInt:p] forKey:@"page"];
	[userInfo setObject:location forKey:@"location"];
	
	[[AsyncNet instance]
	 addRequestForUrl:imagePath
	 successTarget:self
	 successAction:@selector(asyncPhotoRequestSucceeded:userInfo:)
	 failureTarget:self
	 failureAction:@selector(asyncPhotoRequestFailed:userInfo:)
	 userInfo:userInfo];
	[userInfo release];	
	return nil;
#endif
	
}


- (UIImage *)getLocalImageAtIndex:(int)index Location:(NSString *)location{
	if(location == nil || [location length] == 0)
		return nil;
	
	NSString *imagePath;
	NSBundle *bundle = [NSBundle mainBundle]; 
	NSString *path = [bundle bundlePath];
	imagePath = [NSBundle pathForResource:@"Blocks" ofType:@"png" inDirectory:path];
		
	
	NSString *fixPath = [NSString stringWithFormat:@"file://%@",baseDirectory];
	
	NSString* seriesDirectory = [self getCurrentSeriesDirectory];
	
	if([seriesDirectory length] == 0)
		return nil;
	
	imagePath = [NSString stringWithFormat:@"%@%@/%@",fixPath,seriesDirectory,location];
	
	NSArray *strings = [location componentsSeparatedByString: @"/"];
	NSLog(@"[tmpdata imagePath]: %d,%@", index,imagePath);
	
	if(1 == [strings count]){
		NSString* menuName = @"";
		if(mainMenu == LINGERIE)
			menuName = @"LINGERIE";
		else if(mainMenu == EYELASHES)
			menuName = @"EYELASHES";
		else if(mainMenu == CATEGORIES)
			menuName = @"CATEGORIES";
		else
			return nil;	
		imagePath = [NSString stringWithFormat:@"%@/Media/%@/%@",fixPath,menuName,location];
	}
		
	
	NSString *escapedPath = [imagePath stringByReplacingOccurrencesOfString:@" " 
																 withString:@"%20"];
	NSURL *url = [NSURL URLWithString: escapedPath];
	UIImage *photo = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
	if(photo == nil ){
		NSLog(@"ERROR,[tmpdata imagePath]: %@", imagePath);
		return nil;
	}
	return photo;
	
}

- (void)fetchLocalPhotoAtIndex:(int)index Location:(NSString *)location Type:(int)t Page:(int)p
{
	
	if(location == nil || [location length] == 0)
		return;
		
	int startId = [self getCurrentSeriesStartId:0];
	int idx = index + startId;
	
	UIImage *photo = [self getLocalImageAtIndex:idx Location:location];
	if(photo == nil ){
		NSLog(@"ERROR, fetchLocalPhotoAtIndex:%d, %@", idx,location);
		return;
	}
	
	switch(t){
		case kTagSeriesView:			
			[photoGallery fetchedPhoto:photo atIndex:index atPage:p Location:location];
			break;
		case kTagSeriesDetailView:
			[photoGallery fetchedPhoto2:photo atIndex:index atPage:p Location:location];
			break;
		case kTagBigpictureView:
			[photoGallery fetchedPhoto3:photo atIndex:index atPage:p Location:location];
			break;
		case kTagThumbView:
			[photoGallery fetchedPhotoThumb:photo atIndex:index];
			break;
		default:
			break;			
	}	
	
}

- (CGFloat)textWidthByFontSize:(NSString *)text FontSize:(int)fontSize
{
  	//[UIFont systemFontOfSize:fontSize]
	CGSize constraint = CGSizeMake(20000.0f,80);
	CGSize size = [text sizeWithFont:[UIFont fontWithName:@"Arial" size: fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeClip];
	CGFloat width = MAX(size.width, 120.0f);
	return width;
	
}

@end
