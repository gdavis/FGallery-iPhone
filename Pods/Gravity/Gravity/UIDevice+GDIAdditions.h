//
//  UIDevice+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 5/24/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// screen size definitions for different iOS devices.
// sizes are displayed in portrait orientation. 
typedef enum GDIDeviceScreenSize {
    GDIDeviceScreenSize320x480 = 0,     // standard iphone, ipod touch size
    GDIDeviceScreenSize320x568,         // iphone 5
    GDIDeviceScreenSize768x1024,        // ipad
                                        // ipad mini
    GDIDeviceScreenSizeUnknown
} GDIDeviceScreenSize;

@interface UIDevice (GDIAdditions)

+ (BOOL)isRetina;
+ (GDIDeviceScreenSize)deviceScreenSize;

// adopted from StackOverflow: http://stackoverflow.com/a/3950748/189292
+ (NSString *)platform;
+ (NSString *)platformString;

+ (BOOL)isOS7OrLater;

@end
