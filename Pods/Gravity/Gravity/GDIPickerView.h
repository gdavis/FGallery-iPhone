//
//  GDIPickerView.h
//  Gravity
//
//  Created by Grant Davis on 9/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDIPickerView : UIPickerView {
    CGPoint _touchPoint;
}

@property (nonatomic) CGFloat sideMargin;

@end
