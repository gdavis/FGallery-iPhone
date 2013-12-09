//
//  UIColor+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 2/3/12.
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

#import <Foundation/Foundation.h>

@interface UIColor(GDIAdditions)

+ (UIColor *)colorWithRGBHex:(uint)hex;
+ (UIColor *)colorWithRGBHex:(uint)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithARGBHex:(uint)hex;
+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha rgbDivisor:(CGFloat)divisor;
+ (UIColor *)randomColor;
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;
+ (UIColor *)interpolateBetweenColor:(UIColor *)color1 color:(UIColor *)color2 amount:(CGFloat)amount;

@end
