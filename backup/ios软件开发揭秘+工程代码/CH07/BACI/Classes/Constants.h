//
// File: Constants.h
// Abstract: Constant screen placement values for controls.
// Version: 1.0
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

#define kCustomButtonHeight		30.0

// keys to our dictionary holding info on each page
#define kViewControllerKey		@"viewController"
#define kTitleKey				@"title"
#define kDetailKey				@"detail text"

typedef enum{
	kTagLanguageView = 601,
	kTagMainmenuView,
	kTagSeriesView,
	kTagSeriesDetailView,
	kTagBigpictureView,
	kTagThumbView,
	kTagVideoView,
	kTagFullPhotoView,
} TagSystemViews;

typedef enum{
	LINGERIE = 0,
	EYELASHES,
	CATEGORIES,
} TagCategoryIds;

#define SLIDESHOW_SERIES        1
#define SLIDESHOW_SERIESDETAILS 2
#define SLIDESHOW_BIGPICTURE    3
#define SLIDESHOW_THUMBS        4

#define DOWNLOAD_TIMEOUT    60.0
#define UPLOAD_TIMEOUT		60.0
#define FONT_SIZE           14.0f
#define CELL_CONTENT_WIDTH  320.0f
#define CELL_CONTENT_MARGIN 10.0f

#define RELEAE_DEVICE     1
#define HAVE_ANIMATION    1
#define WITH_SEVENUC      0
#define DEBUG_LANDSCAPE   0
#define GEN_SECURITY_DATA 0
#define IPAD_322_RELEASE  1
#define INIT_CHECK_IMAGE  0
#define OPTIMAZE_PAGING   1
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define SHOW_BACI_BACKGROUND  1

// Predefined colors to alternate the background color of each cell row by row
// (see tableView:cellForRowAtIndexPath: and tableView:willDisplayCell:forRowAtIndexPath:).
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]

// 
#define DEVELOPER_DEBUG            0
#define NETWORK_SUPPORT            1
#define NETWORK_SUPPORT_MOVIE_ONLY 1


