//
//  GDIPhoneNumberFormatting.m
//  Gravity
//
//  Created by Grant Davis on 8/10/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIPhoneNumberFormatting.h"

#define kAllowedCharacters @"0123456789()-+"

@interface GDIPhoneNumberFormatting ()

+ (NSString*)formatNumber:(NSString*)mobileNumber;
+ (int)getLength:(NSString*)mobileNumber;

@end


@implementation GDIPhoneNumberFormatting

#pragma mark - Phone Number Field Formatting

// Adopted from: http://stackoverflow.com/questions/6052966/phone-number-formatting
+ (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // if the incoming string is not a phone-friendly character, bail out.
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:kAllowedCharacters];
    if ([string rangeOfCharacterFromSet:allowedCharacters].location == NSNotFound && string.length > 0) {
        return NO;
    }
    
    int length = [GDIPhoneNumberFormatting getLength:textField.text];
    
    if(length == 10) {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3) {
        NSString *num = [GDIPhoneNumberFormatting formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6) {
        NSString *num = [GDIPhoneNumberFormatting formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    return YES;
}


+ (BOOL)textView:(UITextView *)textView shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // if the incoming string is not a phone-friendly character, bail out.
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:kAllowedCharacters];
    if ([string rangeOfCharacterFromSet:allowedCharacters].location == NSNotFound && string.length > 0) {
        return NO;
    }
    
    int length = [GDIPhoneNumberFormatting getLength:textView.text];
    
    if(length == 10) {
        if(range.length == 0)
            return NO;
    }
    
    if(length == 3) {
        NSString *num = [GDIPhoneNumberFormatting formatNumber:textView.text];
        textView.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textView.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6) {
        NSString *num = [GDIPhoneNumberFormatting formatNumber:textView.text];
        textView.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textView.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    return YES;
}


+ (NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    if(length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}


+ (int)getLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    return length;
}

+ (NSString*)formatStringAsPhoneNumber:(NSString*)phoneNumber
{
    NSString *cleanNumber = [[GDIPhoneNumberFormatting formatNumber:phoneNumber]
                             stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    
    int length = [GDIPhoneNumberFormatting getLength:cleanNumber];
    
    if (length < 3) {
        return cleanNumber;
    }
    else if (length == 3) {
        return [NSString stringWithFormat:@"(%@)", cleanNumber];
    }
    else if (length <= 6) {
        return [NSString stringWithFormat:@"(%@) %@",[cleanNumber  substringToIndex:3],[cleanNumber substringFromIndex:3]];
    }
    else if (length > 6) {
        return [NSString stringWithFormat:@"(%@) %@-%@",
                [cleanNumber  substringToIndex:3],
                [cleanNumber substringWithRange:NSMakeRange(3, 3)],
                [cleanNumber substringFromIndex:6]];
    }

    return nil;
}


@end
