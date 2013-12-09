//
//  GDICoreDataStack.m
//  Gravity
//
//  Created by Grant Davis on 9/12/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDICoreDataStack.h"

NSString * const CORE_DATA_STACK_DID_REBUILD_DATABASE = @"CORE_DATA_STACK_DID_REBUILD_DATABASE";

@implementation GDICoreDataStack {
    NSString *_storeName;
    NSString *_seedPath;
    NSString *_configuration;
}

@synthesize mainContext = _mainContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark - Public API

- (id)initWithStoreName:(NSString *)storeName seedName:(NSString *)seedName configuration:(NSString *)config
{
    if (self = [super init]) {
        _storeName = storeName;
        _seedPath = seedName != nil ? [[NSBundle mainBundle] pathForResource:seedName ofType:nil] : nil;
        _configuration = config;
        _shouldRebuildDatabaseIfPersistentStoreSetupFails = YES;
    }
    return self;
}

- (id)initWithManagedObjectModel:(NSManagedObjectModel *)model storeName:(NSString *)storeName seedName:(NSString *)seedName configuration:(NSString *)config;
{
    if (self = [super init]) {
        _managedObjectModel = model;
        _storeName = storeName;
        _seedPath = seedName != nil ? [[NSBundle mainBundle] pathForResource:seedName ofType:nil] : nil;
        _configuration = config;
        _shouldRebuildDatabaseIfPersistentStoreSetupFails = YES;
    }
    return self;
}


- (NSPersistentStoreCoordinator *)setupCoreDataStackWithCompletion:(void (^)(BOOL success, NSError *error))completion
{
    NSError *error = nil;
    if (_seedPath) {
        NSString *storePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storeName] path];
        BOOL success = [self copySeedDatabaseIfNecessaryFromPath:_seedPath
                                                          toPath:storePath
                                                           error:&error];
        if (! success) {
            NSLog(@"Failed to copy seed database at path: %@", _seedPath);
            if (completion) {
                completion(NO, error);
            }
            return nil;
        }
    }
    
    if (_persistentStoreCoordinator == nil) {
        NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption: @YES,
                                   NSInferMappingModelAutomaticallyOption: @YES };
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:_configuration
                                                                 URL:self.storeURL
                                                             options:options
                                                               error:&error])
        {
            if (_shouldRebuildDatabaseIfPersistentStoreSetupFails) {
                NSLog(@"error opening persistent store, removing");
                
                error = nil;
                if (![[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:&error]) {
                    NSLog(@"error removing persistent store %@, giving up", self.storeURL);
                }
                else {
                    NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                         configuration:_configuration
                                                                                                   URL:self.storeURL
                                                                                               options:options
                                                                                                 error:&error];
                    
                    if (store != nil) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:CORE_DATA_STACK_DID_REBUILD_DATABASE object:self];
                    }
                    else {
                        NSLog(@"error opening persistent store, giving up");
                    }
                }
            }
        }
    }
    
    if (completion) {
        completion(_persistentStoreCoordinator != nil, error);
    }
    
    return _persistentStoreCoordinator;
}


- (BOOL)save
{
    BOOL success = NO;
    
    NSError *error = nil;
    @try {
        success = [self.mainContext save:&error];
    }
    @catch (NSException *exception) {
        // This handles the case of exception causing events like validation failures that would otherwise
        // crasp the app.
        NSLog(@"Exception in CoreData save:\n%@\nUserInfo:\n%@", exception, exception.userInfo);
    }
    
    if (!success && error != nil ) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    return success;
}


#pragma mark - Worker Methods

- (BOOL)copySeedDatabaseIfNecessaryFromPath:(NSString *)seedPath toPath:(NSString *)storePath error:(NSError **)error
{
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSError *localError;
        if (![[NSFileManager defaultManager] copyItemAtPath:seedPath toPath:storePath error:&localError]) {
            NSLog(@"Failed to copy seed database from path '%@' to path '%@': %@", seedPath, storePath, [localError localizedDescription]);
            if (error) *error = localError;
            return NO;
        }
        NSLog(@"Successfully copied seed database!");
    }
    return YES;
}


#pragma mark - Context

- (NSManagedObjectContext *)newContext
{
    return [self newContextWithMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy
                           concurrencyType:NSPrivateQueueConcurrencyType];
}


- (NSManagedObjectContext *)newContextWithMergePolicy:(id)mergePolicy
{
    return [self newContextWithMergePolicy:mergePolicy
                           concurrencyType:NSPrivateQueueConcurrencyType];
}


- (NSManagedObjectContext *)newContextWithMergePolicy:(id)mergePolicy
                                      concurrencyType:(NSManagedObjectContextConcurrencyType)type
{
    NSManagedObjectContext *context;
    if (self.persistentStoreCoordinator != nil) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
        context.persistentStoreCoordinator = self.persistentStoreCoordinator;
        context.mergePolicy = mergePolicy;
        context.undoManager = nil;
    }
    return context;
}


- (void)mergeChangesFromContextDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *moc = [notification object];
    if (moc != _mainContext && moc.persistentStoreCoordinator == _mainContext.persistentStoreCoordinator) {
        [_mainContext performBlock:^{
            [_mainContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}


#pragma mark - Accessors

- (NSURL *)storeURL
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storeName];
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}


- (NSManagedObjectContext *)mainContext
{
    NSAssert([NSThread isMainThread], @"This context must be accessed on the main thread!");
    if (_mainContext == nil) {
        NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _mainContext = [self newContextWithMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy
                                           concurrencyType:NSMainQueueConcurrencyType];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(mergeChangesFromContextDidSaveNotification:)
                                                         name:NSManagedObjectContextDidSaveNotification
                                                       object:nil];
        }
    }
    return _mainContext;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    NSArray *directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return (directories.count > 0) ? [directories objectAtIndex:0] : nil;
}


@end
