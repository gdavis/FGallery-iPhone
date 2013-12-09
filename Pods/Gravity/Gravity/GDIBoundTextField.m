//
//  GDIBoundTextField.m
//  Gravity
//
//  Created by Grant Davis on 6/18/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIBoundTextField.h"
#import "NSString+GDIAdditions.h"

@interface GDIBoundTextField () {
    BOOL _isSettingText;
    __weak NSObject *_boundObject;
    NSString *_boundKeypath;
}

- (void)addObserverForTextChanges;
- (void)updateBoundObjectValue;
- (void)updateTextByTrimmingIfNecessary;

@end


@implementation GDIBoundTextField
@synthesize shouldTrimInput;
@synthesize excludedText;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        shouldTrimInput = YES;
        [self addObserverForTextChanges];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        shouldTrimInput = YES;
        [self addObserverForTextChanges];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeBind];
}


- (void)addObserverForTextChanges
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBoundObjectValue) name:UITextFieldTextDidChangeNotification object:self];
}


- (void)bindTextToObject:(NSObject *)obj keyPath:(NSString *)keypath
{
    // remove bind to previous object
    [self removeBind];
    
    // store references
    _boundObject = obj;
    _boundKeypath = keypath;
    
    // bind to new object
    if (_boundObject && _boundKeypath) {
        
        // register KVO observer
        [_boundObject addObserver:self forKeyPath:_boundKeypath options:NSKeyValueObservingOptionNew context:nil];
        
        // set our text to the value of our object's keypath
        NSString *boundValue = [_boundObject valueForKeyPath:_boundKeypath];
        [super setText:boundValue];
    }
}


- (void)setText:(NSString *)text
{
    [super setText:text];
    [self updateBoundObjectValue];
}


- (void)removeBind
{
    if (_boundObject && _boundKeypath) {
        [_boundObject removeObserver:self forKeyPath:_boundKeypath];
    }
    _boundObject = nil;
    _boundKeypath = nil;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:_boundKeypath] && !_isSettingText) {
        NSString *newText = [change objectForKey:NSKeyValueChangeNewKey];
        if (![NSString isNullString:newText]) {
            super.text = newText;
        }
        else {
            super.text = nil;
        }
    }
}


- (void)updateBoundObjectValue
{
    if (_boundObject && _boundKeypath) {
        NSString *storedValue = [_boundObject valueForKeyPath:_boundKeypath];
        
        // create final text string to update our bound object with
        // by first removing any exluded strings
        NSString *finalText = nil;
        if (![NSString isNullString:self.excludedText]) {
            finalText = [self.text stringByReplacingOccurrencesOfString:self.excludedText withString:@""];
        }
        else {
            finalText = self.text;
        }
        
        if (shouldTrimInput) {
            finalText = [finalText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        if (![storedValue isEqualToString:finalText]) {
            @try {
                _isSettingText = YES;
                
                if (![NSString isNullString:finalText]) {
                    [_boundObject setValue:finalText forKeyPath:_boundKeypath];
                }
                else {
                    [_boundObject setValue:nil forKeyPath:_boundKeypath];
                }
            }
            @catch (NSException *exception) {
                // silently handle the error
                NSLog(@"Encountered an errow updating the bound object value: %@", exception);
            }
            @finally {
                _isSettingText = NO;
            }
        }
    }
}


- (void)updateTextByTrimmingIfNecessary
{
    if (shouldTrimInput && ![NSString isNullString:self.text]) {
        super.text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}


- (BOOL)resignFirstResponder
{
    [self updateBoundObjectValue];
    [self updateTextByTrimmingIfNecessary];
    return [super resignFirstResponder];
}

@end
