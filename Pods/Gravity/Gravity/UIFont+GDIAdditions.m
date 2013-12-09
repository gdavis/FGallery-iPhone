//
//  UIFont+GDIAdditions.m
//  Gravity
//
//  Created by Grant Davis on 7/20/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIFont+GDIAdditions.h"

@implementation UIFont (GDIAdditions)

+ (void)logInstalledFonts
{
    NSArray *fonts = [UIFont familyNames];
    for (NSString *familyName in fonts) {
        NSArray *fontNamesInFamily = [UIFont fontNamesForFamilyName:familyName];
        NSLog(@"%@ Family (%i)", familyName, fontNamesInFamily.count);
        for (NSString *fontName in fontNamesInFamily) {
            NSLog(@"\t - %@", fontName);
        }
    }
}

@end
