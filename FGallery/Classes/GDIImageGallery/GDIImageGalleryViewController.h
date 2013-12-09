//
//  GDIImageGalleryViewController.h
//  FGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GDIImageGalleryPhotoView.h"
#import "GDIImageGalleryPhoto.h"


typedef enum
{
	FGalleryPhotoSizeThumbnail,
	FGalleryPhotoSizeFullsize
} FGalleryPhotoSize;

typedef enum
{
	FGalleryPhotoSourceTypeNetwork,
	FGalleryPhotoSourceTypeLocal
} FGalleryPhotoSourceType;

@protocol GDIImageGalleryViewControllerDelegate;

@interface GDIImageGalleryViewController : UIViewController <UIScrollViewDelegate,
                                                        FGalleryPhotoDelegate,
                                                        FGalleryPhotoViewDelegate>

- (id)initWithPhotoSource:(NSObject<GDIImageGalleryViewControllerDelegate>*)photoSrc;
- (id)initWithPhotoSource:(NSObject<GDIImageGalleryViewControllerDelegate>*)photoSrc barItems:(NSArray*)items;

- (void)next;
- (void)previous;
- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeImageAtIndex:(NSUInteger)index;
- (void)reloadGallery;
- (GDIImageGalleryPhoto*)currentPhoto;

@property NSInteger currentIndex;
@property NSInteger startingIndex;
@property (nonatomic,unsafe_unretained) NSObject<GDIImageGalleryViewControllerDelegate> *photoSource;
@property (nonatomic,readonly) UIToolbar *toolBar;
@property (nonatomic,readonly) UIView* thumbsView;
@property (nonatomic) NSString *galleryID;
@property (nonatomic) BOOL useThumbnailView;
@property (nonatomic) BOOL beginsInThumbnailView;
@property (nonatomic) BOOL hideTitle;

@end


@protocol GDIImageGalleryViewControllerDelegate

@required
- (int)numberOfPhotosForPhotoGallery:(GDIImageGalleryViewController*)gallery;
- (FGalleryPhotoSourceType)photoGallery:(GDIImageGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;

@optional
- (NSString*)photoGallery:(GDIImageGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index;

// the photosource must implement one of these methods depending on which FGalleryPhotoSourceType is specified 
- (NSString*)photoGallery:(GDIImageGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index;
- (NSString*)photoGallery:(GDIImageGalleryViewController*)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index;

@end
