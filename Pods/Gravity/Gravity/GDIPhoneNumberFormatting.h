//
//  GDIPhoneNumberFormatting.h
//  Gravity
//
//  Created by Grant Davis on 8/10/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDIPhoneNumberFormatting : NSObject

+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+ (BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
+ (NSString*)formatStringAsPhoneNumber:(NSString*)phoneNumber;

@end
