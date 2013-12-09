//
//  GDITouchProxyViewView.m
//  GDI iOS Core
//
//  Created by Grant Davis on 1/30/12.
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

#import "GDITouchProxyView.h"

@implementation GDITouchProxyView
@synthesize delegate = _delegate;

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchBeganAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchBeganAtPoint:[touch locationInView:self]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if ([_delegate respondsToSelector:@selector(gestureView:touchMovedToPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchMovedToPoint:[touch locationInView:self]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchEndedAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchEndedAtPoint:[touch locationInView:self]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(gestureView:touchEndedAtPoint:)] && [touches count] == 1) {
        UITouch *touch = [touches anyObject];
        [_delegate gestureView:self touchEndedAtPoint:[touch locationInView:self]];
    }
}


@end
