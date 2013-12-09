//
//  UIView+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/15/12.
//  Copyright (c) 2012 rabble+rouser. All rights reserved.
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

#import "UIView+GDIAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (GDIAdditions)
@dynamic frameLeft;
@dynamic frameRight;
@dynamic frameBottom;
@dynamic frameTop;
@dynamic frameWidth;
@dynamic frameHeight;
@dynamic frameOrigin;
@dynamic frameSize;

#pragma mark - Frame Accessors


- (CGFloat)frameLeft
{
    return self.frame.origin.x;
}

- (void)setFrameLeft:(CGFloat)frameLeft
{
    self.frame = CGRectMake(frameLeft, self.frameTop, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)frameRight
{
    self.frame = CGRectMake(frameRight - self.frameWidth, self.frameTop, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)frameBottom
{
    self.frame = CGRectMake(self.frameLeft, frameBottom - self.frameHeight, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameTop
{
    return self.frame.origin.y;
}

- (void)setFrameTop:(CGFloat)frameTop
{
    self.frame = CGRectMake(self.frameLeft, frameTop, self.frameWidth, self.frameHeight);
}


- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
    self.frame = CGRectMake(self.frameLeft, self.frameTop, frameWidth, self.frameHeight);
}


- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
    self.frame = CGRectMake(self.frameLeft, self.frameTop, self.frameWidth, frameHeight);
}


- (CGPoint)frameOrigin
{
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin
{
    self.frame = CGRectMake(frameOrigin.x, frameOrigin.y, self.frameWidth, self.frameHeight);
}


- (CGSize)frameSize
{
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)frameSize
{
    self.frame = CGRectMake(self.frameLeft, self.frameTop, frameSize.width, frameSize.height);
}


- (void)toggleDebugOutline:(BOOL)onOff
{
    [self toggleDebugOutline:onOff color:[UIColor colorWithRed:1.f green:0.f blue:1.f alpha:1.f]];
}

- (void)toggleDebugOutline:(BOOL)onOff color:(UIColor *)color
{
    if (onOff) {
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 4.0;
    }
    else {
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0.f;
    }
}


#pragma mark - Instance Methods

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (UIImage*)imageOfView
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

#pragma mark - Class Methods

+ (UIView *)viewFromNib:(NSString*)nibName
{
    NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    UIView *view = nil;
    for (UIView *nibView in nibItems) {
        view = nibView;
        break;
    }
    return view;
}


+ (UIView *)viewFromNib:(NSString *)nibName withClass:(Class)klass
{
    NSArray *nibItems = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    UIView *view = nil;
    for (UIView *nibView in nibItems) {
        if ([nibView isKindOfClass:klass]) {
            view = nibView;
            break;
        }
    }
    return view;
}

@end
