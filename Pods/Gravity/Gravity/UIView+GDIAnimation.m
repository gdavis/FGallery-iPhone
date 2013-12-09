//
//  UIView+GDIAnimation.m
//  Gravity
//
//  Created by Grant Davis on 7/13/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "UIView+GDIAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "CAAnimation+Blocks.h"

#define kDefaultAnimationTime .333f
#define kBounceKey @"bounce"

@implementation UIView (GDIAnimation)

#pragma mark - Fade In

- (void)fadeIn
{
    [self fadeInWithCompletion:nil];
}

- (void)fadeInWithCompletion:(void (^)(BOOL success))complete
{
    [self fadeInWithDuration:kDefaultAnimationTime animationOptions:0 completion:complete];
}

- (void)fadeInWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL success))complete
{
    [self fadeInWithDuration:duration animationOptions:0 completion:complete];
}

- (void)fadeInWithDuration:(NSTimeInterval)duration 
          animationOptions:(NSUInteger)options 
                completion:(void (^)(BOOL success))complete
{
    self.hidden = NO;
    if (self.alpha == 1.f) {
        self.alpha = 0.f;
    }
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.alpha = 1.f;
    } completion:complete];
}

#pragma mark - Fade Out

- (void)fadeOut
{
    [self fadeOutWithCompletion:nil];
}

- (void)fadeOutWithCompletion:(void (^)(BOOL success))complete
{
    [self fadeOutWithDuration:kDefaultAnimationTime animationOptions:0 completion:complete];
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration completion:(void (^)(BOOL success))complete
{
    [self fadeOutWithDuration:duration animationOptions:0 completion:complete];
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration 
           animationOptions:(NSUInteger)options 
                 completion:(void (^)(BOOL success))complete
{
    self.hidden = NO;
    if (self.alpha == 0.f) {
        self.alpha = 1.f;
    }
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.alpha = 0.f;
    } completion:complete];
}


#pragma mark - Bounce In

- (void)bounceIn
{
    [self bounceInWithCompletion:nil];
}

- (void)bounceInWithCompletion:(void (^)(BOOL success))complete
{    
    CALayer *layer = self.layer;
    CFTimeInterval startTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil] + .1f;
    
    // create the scale animation
    CAKeyframeAnimation *scaleBounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleBounceAnimation.duration = .666f;
    scaleBounceAnimation.beginTime = startTime;
    scaleBounceAnimation.fillMode = kCAFillModeBackwards;
    
    // configure the sizes of the scale for our keyframes
    CATransform3D startingScale = CATransform3DMakeScale(0.1, 0.1, 1);
    CATransform3D oversizedScale = CATransform3DScale(layer.transform, 1.1f, 1.1f, 1.f);
    CATransform3D undersizedScale = CATransform3DScale(layer.transform, .975f, .975f, 1.f);
    CATransform3D finalScale = CATransform3DIdentity;
    
    // store values into array and set
    NSArray *values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:startingScale],
                       [NSValue valueWithCATransform3D:oversizedScale], 
                       [NSValue valueWithCATransform3D:undersizedScale], 
                       [NSValue valueWithCATransform3D:finalScale], 
                       nil];
    [scaleBounceAnimation setValues:values];
    
    // create timings for the keyframe values
    NSArray *timings = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.f], 
                        [NSNumber numberWithFloat:.25f], 
                        [NSNumber numberWithFloat:.5f], 
                        [NSNumber numberWithFloat:1.f], 
                        nil];
    [scaleBounceAnimation setKeyTimes:timings];
    
    // create timing functions to control interpolation between values
    NSArray *timingFunctions = [NSArray arrayWithObjects:
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], 
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], 
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], 
                                nil];
    [scaleBounceAnimation setTimingFunctions:timingFunctions];
    
    
    // create an opacity animation
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.f];
    fadeAnimation.beginTime = startTime;
    fadeAnimation.fillMode = kCAFillModeBackwards;
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeAnimation.duration = .333f;
    fadeAnimation.completion = complete;
    
    // perform the animations
    [layer addAnimation:scaleBounceAnimation forKey:kBounceKey];
    [layer addAnimation:fadeAnimation forKey:nil];
}


#pragma mark - Bounce Out

- (void)bounceOut
{
    [self bounceOutWithCompletion:nil];
}


- (void)bounceOutWithCompletion:(void (^)(BOOL success))complete
{
    CALayer *layer = self.layer;
    [layer removeAnimationForKey:kBounceKey];
    
    // create the scale animation
    CAKeyframeAnimation *scaleBounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    // configure the sizes of the scale for our keyframes
    CATransform3D startingScale = layer.transform;
    CATransform3D oversizedScale = CATransform3DScale(layer.transform, 1.1f, 1.1f, 1.f);
    CATransform3D finalScale = CATransform3DMakeScale(0.1, 0.1, 1);
    
    // store values into array and set
    NSArray *values = [NSArray arrayWithObjects:
                       [NSValue valueWithCATransform3D:startingScale],
                       [NSValue valueWithCATransform3D:oversizedScale],  
                       [NSValue valueWithCATransform3D:finalScale], 
                       nil];
    [scaleBounceAnimation setValues:values];
    
    // create timings for the keyframe values
    NSArray *timings = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.f], 
                        [NSNumber numberWithFloat:.666f], 
                        [NSNumber numberWithFloat:1.f], 
                        nil];
    [scaleBounceAnimation setKeyTimes:timings];
    
    // create timing functions to control interpolation between values
    NSArray *timingFunctions = [NSArray arrayWithObjects:
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], 
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], 
                                nil];
    [scaleBounceAnimation setTimingFunctions:timingFunctions];
    
    
    // create an opacity animation
    CAKeyframeAnimation *fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.keyTimes = timings;
    fadeAnimation.timingFunctions = timingFunctions;
    fadeAnimation.values = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:1.f],
                            [NSNumber numberWithFloat:1.f],
                            [NSNumber numberWithFloat:0.f],
                            nil];
    
    // create a group for the scale and perform the animation
    CAAnimationGroup *bounceGroup = [CAAnimationGroup animation];
    bounceGroup.animations = [NSArray arrayWithObjects:scaleBounceAnimation, fadeAnimation, nil];
    bounceGroup.duration = .5f;
    bounceGroup.fillMode = kCAFillModeBoth;
    bounceGroup.removedOnCompletion = NO;
    bounceGroup.completion = complete;
    [layer addAnimation:bounceGroup forKey:kBounceKey];
}

@end
