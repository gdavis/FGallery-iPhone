//
//  NSManagedObject+Clone.h
//  Gravity
//
//  Adopted from: http://stackoverflow.com/questions/2730832/how-can-i-duplicate-or-copy-a-core-data-managed-object
//
//  Created by Grant Davis on 3/18/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Clone)

// returns a copy of the NSManagedObject with only the attributes values copied from the original
- (NSManagedObject *)cloneShallow;

// returns a copy of the NSManagedObject, as well as copies of all child relationship objects
- (NSManagedObject *)cloneInContext:(NSManagedObjectContext *)context
                    excludeEntities:(NSArray *)namesOfEntitiesToExclude;

@end
