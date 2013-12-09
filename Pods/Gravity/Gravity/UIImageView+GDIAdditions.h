//
//  UIImageView+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 5/21/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GDIAdditions)

- (void)setImageInBackgroundThreadWithName:(NSString *)imageName;
- (void)setImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath;

// this set of methods will load an image in a background thread
// and then creates a scale down version of the image to use as the
// image source for the image view
- (void)setAndResizeImageInBackgroundThreadWithImage:(UIImage *)image;
- (void)setAndResizeImageInBackgroundThreadWithName:(NSString *)imageName;
- (void)setAndResizeImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath;

@end
