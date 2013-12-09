//
//  NSManagedObject+Clone.m
//  Gravity
//
//  Created by Grant Davis on 3/18/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSManagedObject+Clone.h"

@interface NSManagedObject (ClonePrivate)
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                    withCopiedCache:(NSMutableDictionary **)alreadyCopied
                    excludeEntities:(NSArray *)namesOfEntitiesToExclude;
@end


@implementation NSManagedObject (Clone)

- (NSManagedObject *)cloneShallow
{
    NSString *entityName = [[self entity] name];
    
    //create new object in data store
    NSManagedObject *cloned = [NSEntityDescription
                               insertNewObjectForEntityForName:entityName
                               inManagedObjectContext:self.managedObjectContext];
    
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:self.managedObjectContext] attributesByName];
    
    for (NSString *attr in attributes) {
        [cloned setValue:[self valueForKey:attr] forKey:attr];
    }
    
    return cloned;
}



// adopted from: http://stackoverflow.com/a/9546227
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                    withCopiedCache:(NSMutableDictionary **)alreadyCopied
                    excludeEntities:(NSArray *)namesOfEntitiesToExclude
{
    if (!context) {
        return nil;
    }
    NSString *entityName = [[self entity] name];
    
    if ([namesOfEntitiesToExclude containsObject:entityName]) {
        return nil;
    }
    NSManagedObject *cloned = nil;
    if (alreadyCopied != NULL) {
        cloned = [*alreadyCopied objectForKey:[self objectID]];
        if (cloned) {
            return cloned;
        }
        // Create new object in data store
        cloned = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                               inManagedObjectContext:context];
        [*alreadyCopied setObject:cloned forKey:[self objectID]];
    }
    // Loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription entityForName:entityName
                                            inManagedObjectContext:context] attributesByName];
    for (NSString *attr in attributes) {
        [cloned setValue:[self valueForKey:attr] forKey:attr];
    }
    
    // Loop through all relationships, and clone them.
    NSDictionary *relationships = [[NSEntityDescription entityForName:entityName
                                               inManagedObjectContext:context] relationshipsByName];
    NSArray *relationshipKeys = [relationships allKeys];
    for (NSString *relName in relationshipKeys) {
        NSRelationshipDescription *rel = [relationships objectForKey:relName];
        NSString *keyName = [rel name];
        if ([rel isToMany]) {
            if ([rel isOrdered]) {
                // Get a set of all objects in the relationship
                NSMutableOrderedSet *sourceSet = [self mutableOrderedSetValueForKey:keyName];
                NSMutableOrderedSet *clonedSet = [cloned mutableOrderedSetValueForKey:keyName];
                for (id relatedObject in sourceSet) {
                    //Clone it, and add clone to set
                    NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context
                                                                         withCopiedCache:alreadyCopied
                                                                         excludeEntities:namesOfEntitiesToExclude];
                    if (clonedRelatedObject) {
                        [clonedSet addObject:clonedRelatedObject];
                    }
                }
            } else {
                // Get a set of all objects in the relationship
                NSMutableSet *sourceSet = [self mutableSetValueForKey:keyName];
                NSMutableSet *clonedSet = [cloned mutableSetValueForKey:keyName];
                for (id relatedObject in sourceSet) {
                    //Clone it, and add clone to set
                    NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context
                                                                         withCopiedCache:alreadyCopied
                                                                         excludeEntities:namesOfEntitiesToExclude];
                    if (clonedRelatedObject) {
                        [clonedSet addObject:clonedRelatedObject];
                    }
                }
            }
        } else {
            NSManagedObject *relatedObject = [self valueForKey:keyName];
            if (relatedObject) {
                NSManagedObject *clonedRelatedObject = [relatedObject cloneInContext:context
                                                                     withCopiedCache:alreadyCopied
                                                                     excludeEntities:namesOfEntitiesToExclude];
                [cloned setValue:clonedRelatedObject forKey:keyName];
            }
        }
    }
    return cloned;
}

- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                    excludeEntities:(NSArray *)namesOfEntitiesToExclude
{
    NSMutableDictionary* mutableDictionary = [NSMutableDictionary dictionary];
    return [self cloneInContext:context
                withCopiedCache:&mutableDictionary
                excludeEntities:namesOfEntitiesToExclude];
}


@end
