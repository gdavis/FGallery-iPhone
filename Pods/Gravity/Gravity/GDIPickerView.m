//
//  GDIPickerView.m
//  Gravity
//
//  Created by Grant Davis on 9/27/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIPickerView.h"
#import "GDIMath.h"

#define kSideMargin 20.f

@implementation GDIPickerView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.sideMargin = kSideMargin;
    
    // this class uses a tap gesture to replace the default tap functionality
    // provided by Apple. what the default functionality lacks, is the ability to tap on the default
    // unselected row and trigger a change event. by default, there is no way to detect
    // when a use is tapping the center row of a list of content, and they are forced to drag
    // of what they want, then back on to obtain the correct selection.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [tap locationInView:self];
        // now we walk through all our components to see which component
        // our user is interacting with.
        NSUInteger comps = [self.dataSource numberOfComponentsInPickerView:self];
        CGFloat currentWidth = self.sideMargin;
        for (int i=0; i<comps; i++) {
            
            CGSize rowSize = [self rowSizeForComponent:i];
            NSUInteger rows = [self.dataSource pickerView:self numberOfRowsInComponent:i];
            
            // find the component this touch fits into
            if (location.x >= currentWidth && location.x < currentWidth + rowSize.width) {
                
                // then find the row that was tapped
                NSUInteger centerRowIndex = [self selectedRowInComponent:i];
                CGFloat dy = location.y - self.bounds.size.height * .5f;
                
                // include an offset of half a row to account for
                // the middle row being centered across the view.
                if (dy < 0) dy -= rowSize.height * .5;
                else dy += rowSize.height * .5;
                
                // determine the change in the index
                NSInteger di = dy / rowSize.height;
                
                // adjust to a new index
                NSInteger newIndex = centerRowIndex;
                newIndex += di;
                
                // and set it if its within range of the available rows
                if (newIndex >= 0 && newIndex < rows) {
                    [self selectRow:newIndex inComponent:i animated:YES];
                    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
                        [self.delegate pickerView:self didSelectRow:newIndex inComponent:i];
                    }
                    break;
                }
            }
            currentWidth += rowSize.width;
        }
    }
}

@end
