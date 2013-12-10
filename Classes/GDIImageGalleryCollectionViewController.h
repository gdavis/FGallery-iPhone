//
//  GDIThumbnailCollectionViewController.h
//  GDIImageGallery
//
//  Created by Grant Davis on 12/9/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDIImageGalleryViewController;
@protocol GDIImageGalleryViewControllerDelegate, GDIImageGalleryCollectionViewControllerDelegate;
@interface GDIImageGalleryCollectionViewController : UICollectionViewController

@property (nonatomic, weak) GDIImageGalleryViewController *imageGalleryVC;
@property (nonatomic, weak) id <GDIImageGalleryViewControllerDelegate> photoSource;
@property (nonatomic, weak) id <GDIImageGalleryCollectionViewControllerDelegate> delegate;
@property (nonatomic) CGSize thumbnailSize;

@end

@protocol GDIImageGalleryCollectionViewControllerDelegate <NSObject>

- (void)imageGalleryCollectionViewController:(GDIImageGalleryCollectionViewController *)collectionVC
                              didSelectIndex:(NSUInteger)index;

@end
