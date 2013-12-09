//
//  GDIKeyboardObserver.h
//  Gravity
//
//  Created by Grant Davis on 11/19/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDIKeyboardObserverDelegate;

@interface GDIKeyboardObserver : NSObject

extern NSString * const GDIKeyboardDidDockNotification;
extern NSString * const GDIKeyboardDidUndockNotification;

@property (readonly) BOOL isDocked;
@property (readonly) BOOL isVisible;
@property (readonly) BOOL isFitToBottom;
@property (readonly) CGRect keyboardFrame; // relative to the window with orientation applied

+ (GDIKeyboardObserver *)sharedObserver;

@end