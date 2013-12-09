//
//  NSManagedObject+GDIOrderedSetAccessors.m
//  Gravity
//
//  Created by Grant Davis on 8/5/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSManagedObject+GDIOrderedSetAccessors.h"

@implementation NSManagedObject (GDIOrderedSetAccessors)

- (void)insertObject:(id)value atIndex:(NSUInteger)idx forKey:(NSString *)key
{
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:key];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
}


- (void)removeObjectAtIndex:(NSUInteger)idx forKey:(NSString *)key
{
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:key];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
}


- (void)insertValue:(NSArray *)value atIndexes:(NSIndexSet *)indexes forKey:(NSString *)key
{
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:key];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
}


- (void)removeValueAtIndexes:(NSIndexSet *)indexes forKey:(NSString *)key
{
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:key];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
}


- (void)replaceObjectInAtIndex:(NSUInteger)idx withObject:(id)value forKey:(NSString *)key
{
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:key];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:key];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:key];
}


- (void)replaceValuesAtIndexes:(NSIndexSet *)indexes withValues:(NSArray *)values forKey:(NSString *)key
{
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:key];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:values];
    [self setPrimitiveValue:tmpOrderedSet forKey:key];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:key];
}


- (void)addObject:(id)value forKey:(NSString *)key
{
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    NSUInteger idx = [tmpOrderedSet count];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
    [tmpOrderedSet addObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:key];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
}


- (void)removeObject:(id)value forKey:(NSString *)key
{
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    NSUInteger idx = [tmpOrderedSet indexOfObject:value];
    if (idx != NSNotFound) {
        NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
        [tmpOrderedSet removeObject:value];
        [self setPrimitiveValue:tmpOrderedSet forKey:key];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
    }
}


- (void)addValues:(NSOrderedSet *)values forKey:(NSString *)key
{
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSUInteger valuesCount = [values count];
    NSUInteger objectsCount = [tmpOrderedSet count];
    for (NSUInteger i = 0; i < valuesCount; ++i) {
        [indexes addIndex:(objectsCount + i)];
    }
    if (valuesCount > 0) {
        [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
        [tmpOrderedSet addObjectsFromArray:[values array]];
        [self setPrimitiveValue:tmpOrderedSet forKey:key];
        [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:key];
    }
}


- (void)removeValues:(NSOrderedSet *)values forKey:(NSString *)key
{
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:key]];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    for (id value in values) {
        NSUInteger idx = [tmpOrderedSet indexOfObject:value];
        if (idx != NSNotFound) {
            [indexes addIndex:idx];
        }
    }
    if ([indexes count] > 0) {
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
        [tmpOrderedSet removeObjectsAtIndexes:indexes];
        [self setPrimitiveValue:tmpOrderedSet forKey:key];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:key];
    }
}

@end
