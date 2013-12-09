//
//  GDIPageIndicator.m
//  Healthspek
//
//  Created by Grant Davis on 3/2/12.
//  Copyright (c) 2012 Rabble + Rouser. All rights reserved.
//

#import "GDIPageIndicator.h"


@interface GDIPageIndicator()
- (void)initialize;
@end

@implementation GDIPageIndicator
@synthesize totalPages, selectedIndex;
@synthesize dotSpacing;
@synthesize normalDotImage, selectedDotImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    totalPages = 0;
    selectedIndex = 0;
    dotSpacing = 1.f;
}

- (void)setTotalPages:(NSUInteger)pages
{
    totalPages = pages;
    [self setNeedsDisplay];
}

- (void)setSelectedIndex:(NSUInteger)index
{
    selectedIndex = index;
    [self setNeedsDisplay];
}

- (void)setSelectedDotImage:(UIImage *)image
{
    selectedDotImage = image;
    [self setNeedsDisplay];
}

- (void)setNormalDotImage:(UIImage *)image
{
    normalDotImage = image;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (!normalDotImage || !selectedDotImage || totalPages == 0) {
        return;
    }
    
    CGFloat totalWidth = normalDotImage.size.width * totalPages + ((totalPages-1) * dotSpacing);
    CGFloat startX = roundf(rect.size.width * .5 - totalWidth * .5);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    // draw all teh dots
    UIImage *image;
    CGSize imageSize;
    CGFloat dx = startX;
    CGFloat dy;
    for (int i=0; i < totalPages; i++) {
            
        if (i == selectedIndex) {
            image = selectedDotImage;
        }
        else {
            image = normalDotImage;
        }
        
        imageSize = image.size;
        dy = roundf(rect.size.height * .5 - imageSize.height * .5);
        
        CGContextDrawImage(context, CGRectMake(dx, dy, imageSize.width, imageSize.height), [image CGImage]);
        
        dx += imageSize.width + dotSpacing;
    }
}

@end
