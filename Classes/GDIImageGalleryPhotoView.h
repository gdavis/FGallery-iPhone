//
//  GDIImageGalleryPhotoView.h
//  GDIImageGallery
//
//  Created by Grant Davis on 5/19/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol GDIImageGalleryPhotoViewDelegate;

//@interface GDIImageGalleryPhotoView : UIImageView {
@interface GDIImageGalleryPhotoView : UIScrollView <UIScrollViewDelegate> {
	
	UIImageView *imageView;
	UIActivityIndicatorView *_activity;
	UIButton *_button;
	BOOL _isZoomed;
	NSTimer *_tapTimer;
	NSObject <GDIImageGalleryPhotoViewDelegate> *__unsafe_unretained photoDelegate;
}

- (void)killActivityIndicator;

// inits this view to have a button over the image
- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (void)resetZoom;

@property (nonatomic,unsafe_unretained) NSObject <GDIImageGalleryPhotoViewDelegate> *photoDelegate;
@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,readonly) UIButton *button;
@property (nonatomic,readonly) UIActivityIndicatorView *activity;

@end



@protocol GDIImageGalleryPhotoViewDelegate

// indicates single touch and allows controller repsond and go toggle fullscreen
- (void)didTapPhotoView:(GDIImageGalleryPhotoView*)photoView;

@end

