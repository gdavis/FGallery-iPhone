//
//  GDIPageIndicator.h
//  Healthspek
//
//  Created by Grant Davis on 3/2/12.
//  Copyright (c) 2012 Rabble + Rouser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDIPageIndicator : UIView

@property (nonatomic) NSUInteger totalPages;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic) CGFloat dotSpacing;
@property (strong, nonatomic) UIImage *normalDotImage;
@property (strong, nonatomic) UIImage *selectedDotImage;

@end
