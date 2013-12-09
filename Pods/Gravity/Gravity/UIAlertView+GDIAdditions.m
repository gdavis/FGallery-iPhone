//
//  UIAlertView+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 5/30/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIAlertView+GDIAdditions.h"

@implementation UIAlertView (GDIAdditions)

+ (void)debugAlertWithError:(NSError *)error
{
    #ifdef DEBUG
    #ifdef __i386__
    UIAlertView *debugAlert = [[UIAlertView alloc] initWithTitle:error.domain 
                                                         message:[NSString stringWithFormat:@"Description: \n%@\n\nFailure Reason:\n%@", error.localizedDescription, error.localizedFailureReason] 
                                                        delegate:nil 
                                               cancelButtonTitle:@"Continue" 
                                               otherButtonTitles:nil];
    [debugAlert show];
    #endif
    #endif
}

@end
