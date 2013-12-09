//
//  CAAnimation+Blocks.m
//  CAAnimationBlocks
//
//  Created by xissburg on 7/7/11.
//  Copyright 2011 xissburg. All rights reserved.
//

#import "CAAnimation+Blocks.h"


@interface CAAnimationDelegate : NSObject {
    void (^_completion)(BOOL);
    void (^_start)();
}

@property (nonatomic, copy) void (^completion)(BOOL);
@property (nonatomic, copy) void (^start)();

- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end


@implementation CAAnimationDelegate

@synthesize completion=_completion;
@synthesize start=_start;

- (id)init
{
    self = [super init];
    if (self) {
        self.completion = nil;
        self.start = nil;
    }
    return self;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.start != nil) {
        self.start();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completion != nil) {
        self.completion(flag);
    }
}

@end



@implementation CAAnimation (BlocksAddition)

-  (BOOL)delegateCheck
{
    if (self.delegate != nil && ![self.delegate isKindOfClass:[CAAnimationDelegate class]]) {
        NSLog(@"CAAnimation(BlocksAddition) Warning: CAAnimation instance's delegate was modified externally");
        return NO;
    }
    return YES;
}

- (void)setCompletion:(void (^)(BOOL))completion
{
    CAAnimationDelegate *newDelegate = [[CAAnimationDelegate alloc] init];
    newDelegate.completion = completion;
    newDelegate.start = ((CAAnimationDelegate *)self.delegate).start;
    self.delegate = newDelegate;
}

- (void (^)(BOOL))completion
{
    if (![self delegateCheck]) {
        return nil;
    }
    return ((CAAnimationDelegate *)self.delegate).completion;
}

- (void)setStart:(void (^)())start
{
    CAAnimationDelegate *newDelegate = [[CAAnimationDelegate alloc] init];
    newDelegate.start = start;
    newDelegate.completion = ((CAAnimationDelegate *)self.delegate).completion;
    self.delegate = newDelegate;
}

- (void (^)())start
{
    if (![self delegateCheck]) {
        return nil;
    }
    return ((CAAnimationDelegate *)self.delegate).start;
}

@end
