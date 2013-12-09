//
//  UIView+GDIAnimation.h
//  Gravity
//
//  Created by Grant Davis on 7/13/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GDIAnimation)

- (void)fadeIn;
- (void)fadeInWithCompletion:(void (^)(BOOL success))complete;
- (void)fadeInWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL success))complete;
- (void)fadeInWithDuration:(NSTimeInterval)duration 
           animationOptions:(NSUInteger)options 
                 completion:(void (^)(BOOL success))complete;

- (void)fadeOut;
- (void)fadeOutWithCompletion:(void (^)(BOOL success))complete;
- (void)fadeOutWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL success))complete;
- (void)fadeOutWithDuration:(NSTimeInterval)duration 
          animationOptions:(NSUInteger)options 
                completion:(void (^)(BOOL success))complete;


- (void)bounceIn;
- (void)bounceInWithCompletion:(void (^)(BOOL success))complete;

- (void)bounceOut;
- (void)bounceOutWithCompletion:(void (^)(BOOL success))complete;

@end
