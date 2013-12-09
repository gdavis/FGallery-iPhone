//
//  UIScrollView+GDIAdditions.h
//  Gravity
//
//  Created by Grant Davis on 8/1/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (GDIAdditions)

- (NSInteger)currentXIndex;
- (CGFloat)currentXIndexPrecise;

- (NSInteger)currentYIndex;
- (CGFloat)currentYIndexPrecise;

@end
