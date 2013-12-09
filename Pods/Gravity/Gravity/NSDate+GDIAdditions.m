//
//  NSDate+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 4/7/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//

#import "NSDate+GDIAdditions.h"

#define kUTCTimeZone @"UTC"
#define kUTCDateFormat @"yyyy-MM-dd HH:mm:ss"

@implementation NSDate (GDIAdditions)


#pragma mark - Instance Methods

- (NSInteger)daysFromDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:self
												  toDate:date options:0];
	NSInteger days = [components day];
	return days;
}


- (BOOL)isDateBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSTimeInterval dateInterval = [self timeIntervalSince1970];
    NSTimeInterval startInterval = [startDate timeIntervalSince1970];
    NSTimeInterval endInterval = [endDate timeIntervalSince1970];
    return dateInterval >= startInterval && dateInterval <= endInterval;
}


+ (NSString *)stringWithUTCFormat:(NSDate *)localDate
{
    static NSDateFormatter *dateFormatter = nil;
    static NSTimeZone *timeZone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];;
        timeZone = [NSTimeZone timeZoneWithName:kUTCTimeZone];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:kUTCDateFormat];
    });
    return [dateFormatter stringFromDate:localDate];
}


#pragma mark - Class Methods

+ (NSDate *)dateFromUTCString:(NSString *)utcString
{
    static NSDateFormatter *dateFormatter = nil;
    static NSTimeZone *timeZone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];;
        timeZone = [NSTimeZone timeZoneWithName:kUTCTimeZone];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:kUTCDateFormat];
    });
    return [dateFormatter dateFromString:utcString];
}


+ (NSInteger)daysBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	NSInteger days = [components day];
	return days;
}


+ (NSDate *)dateWithDaysFromNow:(CGFloat)days
{
    return [NSDate dateWithHoursFromNow:24 * days];
}


+ (NSDate *)dateWithHoursFromNow:(CGFloat)hours 
{
    return [NSDate dateWithMinutesFromNow:60 * hours];
}


+ (NSDate *)dateWithMinutesFromNow:(CGFloat)minutes 
{
    return [NSDate dateWithTimeIntervalSinceNow:60 * minutes];
}


+ (NSDate *)dateWithDays:(CGFloat)days fromDate:(NSDate *)date
{
    return [NSDate dateWithHours:24 * days fromDate:date];
}


+ (NSDate *)dateWithHours:(CGFloat)hours fromDate:(NSDate *)date
{
    return [NSDate dateWithMinutes:60 * hours fromDate:date];
}


+ (NSDate *)dateWithMinutes:(CGFloat)mins fromDate:(NSDate *)date
{
    return [NSDate dateWithTimeInterval:60 * mins sinceDate:date];
}


@end
