//
//  NSDate+Util.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)

- (NSDate*)adjustZeroClockDate;
- (NSDate*)adjustMonthDate;
- (NSDate*)nextMonth;
- (NSDate*)nextDate;
- (NSInteger)age;
@end
