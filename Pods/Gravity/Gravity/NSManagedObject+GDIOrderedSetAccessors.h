//
//  NSManagedObject+GDIOrderedSetAccessors.h
//  Gravity
//
//  Created by Grant Davis on 8/5/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (GDIOrderedSetAccessors)


// this category has custom implementations of for setting relationships
// for NSOrderedSet objects. as of 8/5/12 there is a bug that causes a crash
// with CoreData and NSOrderedSets. this fixes that bug.
// http://stackoverflow.com/questions/7385439/exception-thrown-in-nsorderedset-generated-accessors
- (void)insertObject:(id)value atIndex:(NSUInteger)idx forKey:(NSString *)key;
- (void)removeObjectAtIndex:(NSUInteger)idx forKey:(NSString *)key;
- (void)insertValue:(NSArray *)value atIndexes:(NSIndexSet *)indexes forKey:(NSString *)key;
- (void)removeValueAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key;
- (void)replaceObjectInAtIndex:(NSUInteger)idx withObject:(id)value forKey:(NSString *)key;
- (void)replaceValuesAtIndexes:(NSIndexSet *)indexes withValues:(NSArray *)values forKey:(NSString *)key;
- (void)addObject:(id)value forKey:(NSString *)key;
- (void)removeObject:(id)value forKey:(NSString *)key;
- (void)addValues:(NSOrderedSet *)values forKey:(NSString *)key;
- (void)removeValues:(NSOrderedSet *)values forKey:(NSString *)key;

@end
