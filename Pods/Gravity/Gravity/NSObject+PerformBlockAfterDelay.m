//
//  NSObject+PerformBlockAfterDelay.m
//  Gravity
//
//  Created by Grant Davis on 6/14/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSObject+PerformBlockAfterDelay.h"

@implementation NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block 
          afterDelay:(NSTimeInterval)delay 
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:) 
               withObject:block 
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

@end
