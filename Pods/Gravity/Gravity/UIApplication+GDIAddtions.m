//
//  UIApplication+GDIAddtions.m
//  Gravity
//
//  Created by Grant Davis on 1/7/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIApplication+GDIAddtions.h"

@implementation UIApplication (GDIAddtions)

- (NSString *)version
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
