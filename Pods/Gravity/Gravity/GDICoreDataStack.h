//
//  GDICoreDataStack.h
//  Gravity
//
//  Created by Grant Davis on 9/12/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const CORE_DATA_STACK_DID_REBUILD_DATABASE;

@interface GDICoreDataStack : NSObject

/**
 *  Main CoreData stack properties
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSURL *storeURL;

/**
 *  If the setupCoreDataStackWithCompletion method fails during its first attempt to add the
 *  persistent store to the coordinator, the system will attempt to remove the existing database file
 *  and create a new one. Defaults to YES.
 */
@property (nonatomic) BOOL shouldRebuildDatabaseIfPersistentStoreSetupFails;

/**
 *  Initializes a new instance. The CoreData stack is not yet available after instantiating this object
 *  and needs to be created with the `setupCoreDataStackWithCompletion:` method. If a seed database name
 *  is provided, this class will attempt to make a copy of that seed database to act as the new core data
 *  database.
 *  @param storeName            Name for the CoreData sqlite file
 *  @param seedName             [Optional] Name for the seed database sqlite in the application bundle.
 *  @param configuration        [Optional] Option configuration name to use when creating the persistent store coordinator.
 */
- (id)initWithStoreName:(NSString *)storeName seedName:(NSString *)seedName configuration:(NSString *)config;

/**
 *  Initializes a new instance. The CoreData stack is not yet available after instantiating this object
 *  and needs to be created with the `setupCoreDataStackWithCompletion:` method. If a seed database name
 *  is provided, this class will attempt to make a copy of that seed database to act as the new core data
 *  database.
 *  @param model                The ManagedObjectModel to use for the CoreData store.
 *  @param storeName            Name for the CoreData sqlite file
 *  @param seedName             [Optional] Name for the seed database sqlite in the application bundle.
 *  @param configuration        [Optional] Option configuration name to use when creating the persistent store coordinator.
 */
- (id)initWithManagedObjectModel:(NSManagedObjectModel *)model storeName:(NSString *)storeName seedName:(NSString *)seedName configuration:(NSString *)config;


/**
 *  Performs the synchronous setup of the CoreData stack on a separate background thread. This method will block
 *  until the operation has completed.
 *
 *  @param competion a block fired at the end of the setup method while still on the background thread.
 *  @return a reference to the newly created persistent store coordinator.
 */
- (NSPersistentStoreCoordinator *)setupCoreDataStackWithCompletion:(void (^)(BOOL success, NSError *error))completion;


/**
 *  Performs a save operation on the main context of the core data stack. This will also catch any errors thrown
 *  by the save operation and log the error to the console.
 *  @return a boolean indicating if the save is successful. 
 */
- (BOOL)save;


/** 
 *  Creates a new managed object context with a policy type of NSMergeByPropertyObjectTrumpMergePolicy
 *  and a concurrency type of NSPrivateQueueConcurrencyType.
 *
 *  @return a new context with the persistent store.
 */
- (NSManagedObjectContext *)newContext;
- (NSManagedObjectContext *)newContextWithMergePolicy:(id)mergePolicy;
- (NSManagedObjectContext *)newContextWithMergePolicy:(id)mergePolicy
                                      concurrencyType:(NSManagedObjectContextConcurrencyType)type;

@end
