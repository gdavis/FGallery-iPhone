//
//  GDIImageGalleryViewController.h
//  GDIImageGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GDIImageGalleryPhotoView.h"
#import "GDIImageGalleryPhoto.h"
#import "GDIImageGalleryCollectionViewController.h"

typedef enum
{
	GDIImageGalleryPhotoSizeThumbnail,
	GDIImageGalleryPhotoSizeFullsize
} GDIImageGalleryPhotoSize;

typedef enum
{
	GDIImageGalleryPhotoSourceTypeNetwork,
	GDIImageGalleryPhotoSourceTypeLocal
} GDIImageGalleryPhotoSourceType;

@protocol GDIImageGalleryViewControllerDelegate;

@interface GDIImageGalleryViewController : UIViewController <UIScrollViewDelegate,
                                                        GDIImageGalleryPhotoDelegate,
                                                        GDIImageGalleryPhotoViewDelegate,
                                                        GDIImageGalleryCollectionViewControllerDelegate>

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
@property (nonatomic, unsafe_unretained) NSObject<GDIImageGalleryViewControllerDelegate> *photoSource;
@property (nonatomic, readonly) UIToolbar *toolBar;
//@property (nonatomic, readonly) UIView* thumbsView;
@property (nonatomic, copy) NSString *galleryID;
@property (nonatomic) BOOL useThumbnailView;
@property (nonatomic) BOOL beginsInThumbnailView;
@property (nonatomic) BOOL hideTitle;

// thumbnail collection view
@property (nonatomic, strong) GDIImageGalleryCollectionViewController *collectionViewController;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;

@end


@protocol GDIImageGalleryViewControllerDelegate

@required
- (NSUInteger)numberOfPhotosForPhotoGallery:(GDIImageGalleryViewController*)gallery;
- (GDIImageGalleryPhotoSourceType)photoGallery:(GDIImageGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;

@optional
- (NSString*)photoGallery:(GDIImageGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index;

// the photosource must implement one of these methods depending on which GDIImageGalleryPhotoSourceType is specified 
- (NSString*)photoGallery:(GDIImageGalleryViewController*)gallery filePathForPhotoSize:(GDIImageGalleryPhotoSize)size atIndex:(NSUInteger)index;
- (NSString*)photoGallery:(GDIImageGalleryViewController*)gallery urlForPhotoSize:(GDIImageGalleryPhotoSize)size atIndex:(NSUInteger)index;

@end
