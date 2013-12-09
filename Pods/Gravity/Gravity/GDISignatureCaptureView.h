//
//  GDISignatureCaptureView.h
//  GDI iOS Core
//
//  Created by Grant Davis on 5/14/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDISignatureCaptureView : UIView

@property (nonatomic) CGFloat strokeWidth;
@property (strong, nonatomic) UIColor *strokeColor;
@property (nonatomic) NSUInteger smoothing;

- (UIImage*)imageOfSignature;
- (void)clear;
- (BOOL)hasSignature;

@end
