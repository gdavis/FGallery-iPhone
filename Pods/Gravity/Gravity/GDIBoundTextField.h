//
//  GDIBoundTextField.h
//  Gravity
//
//  Created by Grant Davis on 6/18/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDIBoundTextField : UITextField

// calling this method will invoke KVO on the keypath of the object specified.
// this method acts as a crude replacement for binding NSManagedObjects to UI components,
// ala CocoaBindings, for iOS developemnt
- (void)bindTextToObject:(NSObject *)obj keyPath:(NSString *)keypath;

// removes the bind to a previously set object and keypath
- (void)removeBind;

// flag inidicating whether whitespace should be trimmed from user input
// when saving values to a bound object. defaults to YES.
@property (nonatomic) BOOL shouldTrimInput;

// text value that will be ignored when updating the bound object.
// this is useful for text fields where you want to display a suffix,
// but do not want to actually save the suffix along with the other text
// to the bound object
@property (strong, nonatomic) NSString *excludedText;

@end
