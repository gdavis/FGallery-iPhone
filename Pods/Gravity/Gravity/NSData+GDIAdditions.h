//
//  NSData+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 5/8/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GDIAdditions)

// creates a string with the MD5 representation of this object
// adopted from: http://mobiledevelopertips.com/core-services/create-md5-hash-from-nsstring-nsdata-or-file.html
- (NSString *)MD5;

- (NSData *)gzipInflate;

- (NSData *)gzipDeflate;

@end
