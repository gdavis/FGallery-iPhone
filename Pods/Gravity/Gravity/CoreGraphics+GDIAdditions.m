//
//  CoreGraphics+GDIAdditions.m
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

#import "CoreGraphics+GDIAdditions.h"


void CGContextDrawInnerShadowWithPath(CGContextRef context, CGPathRef shapePath, UIColor *color, CGSize offset, CGFloat radius)
{
    // draw the inner shadow.
    CGRect rect = CGContextGetClipBoundingBox(context);
    CGContextSaveGState(context);
    // create offset for a shaper larger than the viewable path
    CGFloat outsideOffset = 10.f;
    
    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow
    CGMutablePathRef path = CGPathCreateMutable();
    // Draw a big rectange
    CGPathMoveToPoint(path, NULL, -outsideOffset, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, rect.size.width+outsideOffset*2, -outsideOffset);
    CGPathAddLineToPoint(path, NULL, rect.size.width+outsideOffset*2, rect.size.height+outsideOffset*2);
    CGPathAddLineToPoint(path, NULL, -outsideOffset, rect.size.height+outsideOffset*2);
    
    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, shapePath);
    CGPathCloseSubpath(path);
    
    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, shapePath);
    CGContextClip(context); 
    
    // Now setup the shadow properties on the context
    CGContextSetShadowWithColor(context, offset, radius, [color CGColor]);
    
    // Now fill the rectangle, so the shadow gets drawn
    UIColor *aColor = [UIColor colorWithWhite:1.f alpha:1.f];
    [aColor setFill];
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);
    
    CGContextRestoreGState(context);
    
    // Release the paths
    CGPathRelease(path); 
}

void CGContextDrawGradientWithColors(CGContextRef context, CGRect rect, NSArray *colors, CGFloat locations[]) 
{
    // draw gradient fill for background
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (CGRectIsNull(rect)) {
        rect = CGContextGetClipBoundingBox(context);
    }

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGPathRef clipPath = CGPathCreateWithRect(rect, NULL);
    CGContextAddPath(context, clipPath);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

    CGPathRelease(clipPath);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}