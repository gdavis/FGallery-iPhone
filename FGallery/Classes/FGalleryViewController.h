//
//  FGalleryViewController.h
//  FGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FGalleryPhotoView.h"
#import "FGalleryPhoto.h"


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

@protocol FGalleryViewControllerDelegate;

@interface FGalleryViewController : UIViewController <UIScrollViewDelegate,FGalleryPhotoDelegate,FGalleryPhotoViewDelegate> {
	
	BOOL _isActive;
	BOOL _isFullscreen;
	BOOL _isScrolling;
	BOOL _isThumbViewShowing;
	
	UIStatusBarStyle _prevStatusStyle;
	CGFloat _prevNextButtonSize;
	CGRect _scrollerRect;
	NSString *galleryID;
	NSInteger _currentIndex;
	
	UIView *_container; // used as view for the controller
	UIView *_innerContainer; // sized and placed to be fullscreen within the container
	UIToolbar *_toolbar;
	UIScrollView *_thumbsView;
	UIScrollView *_scroller;
	UIView *_captionContainer;
	UILabel *_caption;
	
	NSMutableDictionary *_photoLoaders;
	NSMutableArray *_barItems;
	NSMutableArray *_photoThumbnailViews;
	NSMutableArray *_photoViews;
	
	NSObject <FGalleryViewControllerDelegate> *_photoSource;
    
	UIBarButtonItem *_nextButton;
	UIBarButtonItem *_prevButton;
}

- (id)initWithPhotoSource:(NSObject<FGalleryViewControllerDelegate>*)photoSrc;
- (id)initWithPhotoSource:(NSObject<FGalleryViewControllerDelegate>*)photoSrc barItems:(NSArray*)items;

- (void)next;
- (void)previous;
- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeImageAtIndex:(NSUInteger)index;
- (void)reloadGallery;

@property NSInteger currentIndex;
@property NSInteger startingIndex;
@property (nonatomic,assign) NSObject<FGalleryViewControllerDelegate> *photoSource;
@property (nonatomic,readonly) UIToolbar *toolBar;
@property (nonatomic,readonly) UIView* thumbsView;
@property (nonatomic,retain) NSString *galleryID;
@property (nonatomic) BOOL useThumbnailView;
@property (nonatomic) BOOL beginsInThumbnailView;

@end


@protocol FGalleryViewControllerDelegate

@required
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController*)gallery;
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;

@optional
- (NSString*)photoGallery:(FGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index;

// the photosource must implement one of these methods depending on which FGalleryPhotoSourceType is specified 
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index;
- (NSString*)photoGallery:(FGalleryViewController*)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index;

@end
