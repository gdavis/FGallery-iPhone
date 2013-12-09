//
//  NSDate+GDIAdditions.h
//  GDI iOS Core
//
//  Created by Grant Davis on 4/7/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//



@interface NSDate (GDIAdditions)

// adopted from: http://stackoverflow.com/a/2615847/189292
+ (NSString *)stringWithUTCFormat:(NSDate *)localDate;
+ (NSDate *)dateFromUTCString:(NSString *)utcString;

- (NSInteger)daysFromDate:(NSDate *)date;
- (BOOL)isDateBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSInteger)daysBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSDate *)dateWithDaysFromNow:(CGFloat)days;
+ (NSDate *)dateWithHoursFromNow:(CGFloat)days;
+ (NSDate *)dateWithMinutesFromNow:(CGFloat)days;

+ (NSDate *)dateWithDays:(CGFloat)days fromDate:(NSDate *)date;
+ (NSDate *)dateWithHours:(CGFloat)hours fromDate:(NSDate *)date;
+ (NSDate *)dateWithMinutes:(CGFloat)mins fromDate:(NSDate *)date;

@end
