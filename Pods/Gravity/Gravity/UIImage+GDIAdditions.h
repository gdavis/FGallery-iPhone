//
//  UIImage+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 2/9/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in the 
//  Software without restriction, including without limitation the rights to use, 
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
//  Software, and to permit persons to whom the Software is furnished to do so, 
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN 
//  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

@interface UIImage (GDIAdditions)

// adopted from: http://stackoverflow.com/a/1300589/189292
// returns an image converted to grayscale
- (UIImage *)imageByConvertingToGrayscale;

// returns an image with a tint color applied over the top if it
- (UIImage *)imageWithTintColor:(UIColor *)color;
- (UIImage *)imageWithTintColor:(UIColor *)color useImageAlpha:(BOOL)useAlphaMask;

// returns an image of the receiever cropped to the specified rectangle
- (UIImage *)imageCroppedToRect:(CGRect)rect;

// returns an image of the receiever cropped to the specified rectangle
- (UIImage *)imageCroppedToRect:(CGRect)rect opaque:(BOOL)opaque;

// adopted from: http://stackoverflow.com/questions/1260249/resizing-uiimages-pulled-from-the-camera-also-rotates-the-uiimage
// returns an image of the receiver resized to the specified size
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

// returns an image of the receiver resized to the specified size while
// maintaining the aspect ratio of the image
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

// adopted from: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
// returns and image rotated to match its appropriate EXIT orientation
- (UIImage *)fixOrientation;

// returns an image of the receiever rotated by UIImageOrientation, or EXIF, values
+ (UIImage *)rotateImage:(UIImage*)img imageOrientation:(UIImageOrientation)orient;

// returns a transformation of the speficified rectangle to match given EXIF orientation
- (CGRect)transformRect:(CGRect)rect forEXIFOrientation:(NSUInteger)orientation;

// returns a snapshot of the receiver
+ (UIImage*)imageOfView:(UIView*)view;

// convenience method to return an image from the main bundle
+ (UIImage*)imageFromMainBundleWithName:(NSString*)filename;

@end
