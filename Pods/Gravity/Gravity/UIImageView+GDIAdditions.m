//
//  UIImageView+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 5/21/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIImageView+GDIAdditions.h"
#import "UIImage+GDIAdditions.h"
#import "UIDevice+GDIAdditions.h"

@implementation UIImageView (GDIAdditions)

- (void)setImageInBackgroundThreadWithName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        UIImage *image = [UIImage imageNamed:imageName];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}


- (void)setImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}


- (void)setAndResizeImageInBackgroundThreadWithImage:(UIImage *)image
{
    CGRect rect = self.frame;
    if ([UIDevice isRetina]) {
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(2.f, 2.f));
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        UIImage *resizedImage = [image imageByScalingToSize:rect.size];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.image = resizedImage;
        });
    });
}


- (void)setAndResizeImageInBackgroundThreadWithName:(NSString *)imageName
{
    CGRect rect = self.frame;
    if ([UIDevice isRetina]) {
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(2.f, 2.f));
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        UIImage *resizedImage = [[UIImage imageNamed:imageName] imageByScalingToSize:rect.size];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.image = resizedImage;
        });
    });
}


- (void)setAndResizeImageInBackgroundThreadWithContentsOfFile:(NSString *)filePath
{
    CGRect rect = self.frame;
    if ([UIDevice isRetina]) {
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeScale(2.f, 2.f));
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0ul), ^{
        UIImage *resizedImage = [[UIImage imageWithContentsOfFile:filePath] imageByScalingToSize:rect.size];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.image = resizedImage;
        });
    });
}


@end
