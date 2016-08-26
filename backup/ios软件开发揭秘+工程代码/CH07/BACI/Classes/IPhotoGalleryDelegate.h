//
//  IPhotoGalleryDelegate.h
//  BACI
//
//  Created by Henry Yu on 10-06-19.
//  Copyright 2010 Sevensoft Technology Co., Ltd. All rights reserved.
//

@class IPhotoGallery;

@protocol IPhotoGalleryDelegate <NSObject>

- (int)iPhotoGalleryPhotosCount:(IPhotoGallery *)iPhotoGallery ControllerType:(int)t;
- (void)iPhotoGallery:(IPhotoGallery *)iPhotoGallery
    fetchPhotoThumbAtIndex:(int)index Location:(NSString *)location;
- (void)iPhotoGallery:(IPhotoGallery *)iPhotoGallery
    fetchPhotoAtIndex:(int)index Location:(NSString *)location Type:(int)t Page:(int)p;

@end

