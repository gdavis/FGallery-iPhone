//
//  UIView+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 2/15/12.
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

@interface UIView (GDIAdditions)

/**
 * Frame access convenience methods
 */
@property (nonatomic) CGFloat frameLeft;
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;
@property (nonatomic) CGFloat frameTop;
@property (nonatomic) CGFloat frameHeight;
@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

- (void)toggleDebugOutline:(BOOL)onOff;
- (void)toggleDebugOutline:(BOOL)onOff color:(UIColor *)color;


/**
 * Removes all child subviews
*/
- (void)removeAllSubviews;

/**
 * @returns a UIImage of the view's current state
 */
- (UIImage*)imageOfView;


/**
 * @returns the first view within the specified nib. 
 */
+ (UIView *)viewFromNib:(NSString*)nibName;
+ (UIView *)viewFromNib:(NSString *)nibName withClass:(Class)klass;


@end