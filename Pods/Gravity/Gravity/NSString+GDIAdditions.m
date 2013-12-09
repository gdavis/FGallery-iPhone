//
//  NSString+GDIAdditions.m
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

#import "NSString+GDIAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (GDIAdditions)

- (NSString *)stringByTruncatingToLength:(NSUInteger)length suffix:(NSString *)suffix
{
    if (self.length <= length) {
        return self;
    }
    
    // find the last whitespace
    NSRange lastWhitespaceRange = [self rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]
                                                        options:NSBackwardsSearch
                                                          range:NSMakeRange(0, length)];
    
    // trim to the whitespace location
    NSString *shortText = nil;
    if (lastWhitespaceRange.location != NSNotFound) {
        shortText = [self substringWithRange:NSMakeRange(0, lastWhitespaceRange.location)];
    }
    // if we don't find whitespace, trim to the given length
    else {
        shortText = [self substringWithRange:NSMakeRange(0, length)];
    }
    
    // make sure the last character is not punctuation
    NSString *lastChar = [shortText substringFromIndex:shortText.length-1];
    if ([lastChar rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].length > 0) {
        shortText = [shortText substringToIndex:shortText.length-1];
    }
    
    // add suffix if needed
    if (suffix) return [shortText stringByAppendingString:suffix];
    return shortText;
}


-(NSString *)stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+ (BOOL)isNullString:(NSString *)string
{    
    if (string == nil 
        || string == (id)[NSNull null] 
        || string.length == 0 
        || [string isEqualToString:@""]  
        || [string isEqualToString:@"null"] 
        || [string isEqualToString:@"(null)"] 
        || [string isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber
{
    NSError *error = nil;
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypePhoneNumber|NSTextCheckingTypePhoneNumber)
                                                               error:&error];
    NSUInteger numberOfMatches = [detector numberOfMatchesInString:phoneNumber
                                                           options:0
                                                             range:NSMakeRange(0, [phoneNumber length])];
    return numberOfMatches > 0;
}

+ (BOOL)isValidEmail:(NSString *)string
{
	// validate data 
	BOOL validated = YES;
    
	if( [string length] == 0 ) validated = NO;
	
	// check for email address
	NSString *emailStr = [string lowercaseString];
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:emailStr];
	if( myStringMatchesRegEx == NO ) validated = NO;
	
	return validated;
}


- (NSString *)stringGroupByFirstInitial
{
    if (!self.length || self.length == 1)
        return self;
    return [self substringToIndex:1];
}

@end
