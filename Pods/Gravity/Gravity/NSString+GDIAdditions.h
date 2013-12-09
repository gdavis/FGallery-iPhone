//
//  NSString+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 3/6/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in the 
//  Software without restriction, including without limitation the rights to use, 
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
//  Software, and to permit persons to whom the Software is furnished to do so, 
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS 
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN 
//  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface NSString (GDIAdditions)

// checks the string value to determine if the contents are null.
// this checks for values such as '<null>' and '(null)' from database fields.
+ (BOOL)isNullString:(NSString *)string;

// returns a string by truncating to the last whitespace character under the given range
// and adds a suffix to the string, such as an ellipsis, if provided.
- (NSString *)stringByTruncatingToLength:(NSUInteger)length suffix:(NSString *)suffix;

// removes all characters between <> tags from the reciever and returns the result
- (NSString *)stringByStrippingHTML;

// creates a string with the MD5 representation of this object
// adopted from: http://mobiledevelopertips.com/core-services/create-md5-hash-from-nsstring-nsdata-or-file.html
- (NSString *)MD5;

// this is a helper method that returns the first letter of a string. this is used
// when displaying CoreData results using an NSFetchedResultsController. you can use
// this as the keypath for any string to sort by that group.
// adopted from: http://stackoverflow.com/a/10022171
- (NSString *)stringGroupByFirstInitial;

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;
+ (BOOL)isValidEmail:(NSString *)string;

@end
