//
//  GDIThumbnailCollectionViewController.h
//  GDIImageGallery
//
//  Created by Grant Davis on 12/9/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GDIImageGalleryViewController;
@interface GDIImageGalleryCollectionViewController : UICollectionViewController

@property (nonatomic, weak) GDIImageGalleryViewController *imageGalleryVC;
@property (nonatomic) CGSize thumbnailSize;

@end
