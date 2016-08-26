//
// File: Constants.h
// Abstract: Constant screen placement values for controls.
// Version: 1.0
// 
// Created by Henry Yu on 09-06-17.
// Copyright Sevenuc.com 2010. All rights reserved.
//

#define kCustomButtonHeight		30.0
#define kTagWindowIndicatorView 901
#define kTagWindowIndicator     902

// keys to our dictionary holding info on each page
#define kViewControllerKey		@"viewController"
#define kTitleKey				@"title"
#define kDetailKey				@"detail text"

#define MyDocument              @"MyDocument"
#define MyTeamDocument          @"MyTeamDocument"
#define SearchDocument          @"SearchDocument"

#define RECORD_TABS_IMAGE                 0
#define RECORD_PER_PAGE                   25  //record number of each page
#define MAX_CACHE_PAGES                   2   //maximum number of cached page

#define DOWNLOAD_TIMEOUT                  60.0
#define UPLOAD_TIMEOUT		              60.0
#define FONT_SIZE                         14.0f
#define CELL_CONTENT_WIDTH                320.0f
#define CELL_CONTENT_MARGIN               10.0f

#define DEBUG_SEARCH_VIEW                 0
#define WITH_SEARCHVIEWCONTROLLER         1
#define DEBUG_LOGIN                       0
#define ALLOW_ATTACHMENT_ROW_DOWNLOAD     0

#define	STATUS_BAR_STYLE_DEFAULT          0
#define	STATUS_BAR_STYLE_BLACKOQAUE       1
#define	STATUS_BAR_STYLE_BLACKTRANSLUCENT 2
#define WITH_ASYNCNET_REQUEST             1
#define WITH_CORE_DATA_SUPPORT            1
#define DEFAULT_STATUS_BAR_STYLE          0
// Predefined colors to alternate the background color of each cell row by row
// (see tableView:cellForRowAtIndexPath: and tableView:willDisplayCell:forRowAtIndexPath:).

#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]

// 
#define DEBUG                 0
#define NETWORK               1
#define ALWAYS_LOGIN          1
#define USING_LOCAL_DATA      0
#define UPLOAD_DIRECTORY	  @"/private/var/mobile/Media"
#define DOWNLOAD_DIRECTORY	  @"/private/var/mobile/Media"

