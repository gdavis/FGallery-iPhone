//
//  GDIProgressiveMigration.h
//  Gravity
//
//  Created by Grant Davis on 1/4/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface GDIProgressiveMigration : NSObject

+ (BOOL)shouldMigrateURL:(NSURL *)sourceStoreURL
                  ofType:(NSString*)type
                 toModel:(NSManagedObjectModel *)finalModel
                   error:(NSError **)error;

+ (BOOL)progressivelyMigrateURL:(NSURL*)sourceStoreURL
                         ofType:(NSString*)type
                        toModel:(NSManagedObjectModel*)finalModel
                          error:(NSError**)error;

@end
