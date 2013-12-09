//
//  NSObject+PerformBlockAfterDelay.h
//  Gravity
//
//  Created by Grant Davis on 6/14/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// credit to John Calsbeek on Stack Overflow for formatting the category:
// http://stackoverflow.com/questions/4007023/blocks-instead-of-performselectorwithobjectafterdelay
// credit to Mike Ash for the original implementation:
// http://www.mikeash.com/pyblog/friday-qa-2009-08-14-practical-blocks.html
@interface NSObject (PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block 
          afterDelay:(NSTimeInterval)delay;

@end
