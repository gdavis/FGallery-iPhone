//
//  UILabel+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 2/23/12.
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

@interface UILabel (GDIAdditions)

// "smart" method which attempts to adjust a label based
// on the number of lines and line break mode set.
- (void)adjustSizeToFitText;

// use to adjust the height of a multi-line text field
- (void)adjustWidthToFitText;

// use to adjust the height of a multi-line text field
- (void)adjustHeightToFitText;

// returns a single instance of a UILabel to be used as a quick way to use sizeThatFits
+ (UILabel *)labelForSizing;
+ (UILabel *)labelForSizingWithFont:(UIFont *)font text:(NSString *)text;

@end
