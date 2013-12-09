//
//  GDIAutoFocusingScrollViewController.h
//  Gravity
//
//  Created by Grant Davis on 6/14/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDIAutoFocusingScrollViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

// defaults to YES
@property (nonatomic) BOOL shouldResizeScrollViewWhenKeyboardIsPresent;

- (void)scrollContentViewWithFocusOnSubview:(UIView *)subview animation:(BOOL)animate;

// returns a rect that takes into account the size of the keyboard.
// this method is also available for override for subclasses to customize
// the viewable area
- (CGRect)viewableAreaForOrientation:(UIInterfaceOrientation)orientation;

@end
