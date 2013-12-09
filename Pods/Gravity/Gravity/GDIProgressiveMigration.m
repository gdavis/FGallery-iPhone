//
//  GDIProgressiveMigration.m
//  Gravity
//
//  Created by Grant Davis on 1/4/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIProgressiveMigration.h"

@implementation GDIProgressiveMigration


#pragma mark - Progressive Core Data Model Migrations

+ (BOOL)shouldMigrateURL:(NSURL *)sourceStoreURL
                  ofType:(NSString*)type
                 toModel:(NSManagedObjectModel *)finalModel
                   error:(NSError **)error
{
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type
                                                                                              URL:sourceStoreURL
                                                                                            error:error];
    if (!sourceMetadata) return YES;
    
    return ![finalModel isConfiguration:nil
            compatibleWithStoreMetadata:sourceMetadata];
}


+ (BOOL)progressivelyMigrateURL:(NSURL*)sourceStoreURL
                         ofType:(NSString*)type
                        toModel:(NSManagedObjectModel*)finalModel
                          error:(NSError**)error
{
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type
                                                                                              URL:sourceStoreURL
                                                                                            error:error];
    if (!sourceMetadata) return NO;
    
    if ([finalModel isConfiguration:nil
        compatibleWithStoreMetadata:sourceMetadata]) {
        if (error != NULL) *error = nil;
        return YES;
    }
    
    //Find the source model
    NSManagedObjectModel *sourceModel = [NSManagedObjectModel
                                         mergedModelFromBundles:nil
                                         forStoreMetadata:sourceMetadata];
    NSAssert(sourceModel != nil, ([NSString stringWithFormat:
                                   @"Failed to find source model\n%@", sourceMetadata]));
    //Find all of the mom and momd files in the Resources directory
    NSMutableArray *modelPaths = [NSMutableArray array];
    NSArray *momdArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd"
                                                            inDirectory:nil];
    for (NSString *momdPath in momdArray) {
        NSString *resourceSubpath = [momdPath lastPathComponent];
        NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                            inDirectory:resourceSubpath];
        [modelPaths addObjectsFromArray:array];
    }
    NSArray* otherModels = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                              inDirectory:nil];
    [modelPaths addObjectsFromArray:otherModels];
    if (!modelPaths || ![modelPaths count]) {
        //Throw an error if there are no models
        NSMutableDictionary *dict = [NSMutableDictionary dictionary]; [dict setValue:@"No models found in bundle"
                                                                              forKey:NSLocalizedDescriptionKey];
        //Populate the error
        if (error != NULL) *error = [NSError errorWithDomain:@"Zarra" code:8001 userInfo:dict];
        return NO;
    }
    
    
    // Now the complicated part comes in. Since it is not currently possible
    // to get an NSMappingModel with just the source model and then determine
    // the destination model, we have to instead loop through every model we find,
    // instantiate it, plug it in as a possible destination, and see whether there
    // is a mapping model in existence. If there isn’t, we continue to the next one.
    NSMappingModel *mappingModel = nil; NSManagedObjectModel *targetModel = nil; NSString *modelPath = nil;
    for (modelPath in modelPaths) {
        targetModel = [[NSManagedObjectModel alloc]
                       initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
        mappingModel = [NSMappingModel mappingModelFromBundles:nil
                                                forSourceModel:sourceModel
                                              destinationModel:targetModel];
        //If we found a mapping model then proceed
        if (mappingModel) break;
        //Release the target model and keep looking [targetModel release], targetModel = nil;
    }
    //We have tested every model, if nil here we failed
    if (!mappingModel) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"No models found in bundle"
                forKey:NSLocalizedDescriptionKey];
        if (error != NULL) *error = [NSError errorWithDomain:@"Zarra" code:8001 userInfo:dict];
        return NO;
    }
    
    
    
    NSMigrationManager *manager = [[NSMigrationManager alloc]
                                   initWithSourceModel:sourceModel
                                   destinationModel:targetModel];
    
    NSString *modelName = [[modelPath lastPathComponent]
                           stringByDeletingPathExtension];
    NSString *storeExtension = [[sourceStoreURL path] pathExtension];
    NSString *storePath = [[sourceStoreURL path] stringByDeletingPathExtension];
    //Build a path to write the new store
    storePath = [NSString stringWithFormat:@"%@.%@.%@", storePath,
                 modelName, storeExtension];
    NSURL *destinationStoreURL = [NSURL fileURLWithPath:storePath];
    
    NSLog(@"Performing migration from source model version: %@\nto target model version: %@",
          [sourceModel versionIdentifiers],
          [targetModel versionIdentifiers]);
    
    if (![manager migrateStoreFromURL:sourceStoreURL
                                 type:type
                              options:nil
                     withMappingModel:mappingModel
                     toDestinationURL:destinationStoreURL
                      destinationType:type
                   destinationOptions:nil
                                error:error]) {
        return NO;
    }
    
    //Migration was successful, move the files around to preserve the source
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    guid = [guid stringByAppendingPathExtension:modelName];
    guid = [guid stringByAppendingPathExtension:storeExtension];
    NSString *appSupportPath = [storePath stringByDeletingLastPathComponent];
    NSString *backupPath = [appSupportPath stringByAppendingPathComponent:guid];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager moveItemAtPath:[sourceStoreURL path]
                              toPath:backupPath
                               error:error]) {
        //Failed to copy the file
        return NO;
    }
    //Move the destination to the source path
    if (![fileManager moveItemAtPath:storePath
                              toPath:[sourceStoreURL path]
                               error:error]) {
        //Try to back out the source move first, no point in checking it for errors
        [fileManager moveItemAtPath:backupPath
                             toPath:[sourceStoreURL path]
                              error:nil];
        return NO;
    }
    //We may not be at the "current" model yet, so recurse
    return [self progressivelyMigrateURL:sourceStoreURL
                                  ofType:type
                                 toModel:finalModel
                                   error:error];
}

@end
