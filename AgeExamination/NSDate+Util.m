//
//  NSDate+Util.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

- (NSDate *)adjustZeroClockDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)adjustMonthDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)nextMonth
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit
                                               fromDate:self];
    components.month += 1;
    return [calendar dateFromComponents:components];
}

- (NSDate *)nextDate
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:self];
    components.day += 1;
    return [calendar dateFromComponents:components];
}

- (NSInteger)age
{
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit
                                                                      fromDate:self
                                                                        toDate:now
                                                                       options:0];
    return [ageComponents year];
}

@end
