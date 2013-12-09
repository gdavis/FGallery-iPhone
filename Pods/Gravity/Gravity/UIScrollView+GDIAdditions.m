//
//  UIScrollView+GDIAdditions.m
//  Gravity
//
//  Created by Grant Davis on 8/1/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIScrollView+GDIAdditions.h"

@implementation UIScrollView (GDIAdditions)

- (NSInteger)currentXIndex
{
    return roundf([self currentXIndexPrecise]);
}

- (CGFloat)currentXIndexPrecise
{
    return self.contentOffset.x / self.frame.size.width;
}

- (NSInteger)currentYIndex
{
    return roundf([self currentYIndexPrecise]);
}

- (CGFloat)currentYIndexPrecise
{
    return self.contentOffset.y / self.frame.size.height;
}

@end
