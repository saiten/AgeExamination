//
//  AEEasyResult.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEEasyResult.h"

@implementation AEEasyResultManager

- (id)init
{
    self = [super init];
    if(self) {
        self.results = [NSMutableArray array];
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_results"];
        for(NSData *data in arr) {
            AEEasyResult *result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.results addObject:result];
        }
    }
    return self;
}

+ (instancetype)sharedManager
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (AEEasyResult *)resultForDate:(NSDate *)date
{
    date = [date adjustZeroClockDate];
    for(AEEasyResult *result in self.results) {
        if([result.examDate isEqualToDate:date]) {
            return result;
        }
    }
    return nil;
}

- (void)setResult:(AEEasyResult *)result
{
    [self.results addObject:result];
    [self.results sortUsingComparator:^NSComparisonResult(AEEasyResult *r1, AEEasyResult *r2) {
        return [r1.examDate compare:r2.examDate];
    }];
    [self save];
}

- (void)removeResult:(AEEasyResult *)result
{
    [self.results removeObject:result];
}

- (void)removeAllResults
{
    [self.results removeAllObjects];
    [self save];
}

- (NSArray*)resultsWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSMutableArray *arr = [NSMutableArray array];

    for(AEEasyResult *result in self.results) {
        if([result.examDate compare:startDate] != NSOrderedDescending && [result.examDate compare:endDate] == NSOrderedAscending) {
            [arr addObject:result];
        }
    }
    return arr;
}

- (void)save
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.results.count];
    for(AEEasyResult *result in self.results) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:result];
        [arr addObject:data];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"current_results"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation AEEasyResult

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        self.estimateAge            = [aDecoder decodeIntegerForKey:@"estimate_age"];
        self.bodyAge                = [aDecoder decodeIntegerForKey:@"body_age"];
        self.brainAge               = [aDecoder decodeIntegerForKey:@"brain_age"];
        self.balanceTestTiltSummary = [aDecoder decodeFloatForKey:@"balance_test_tilt_summary"];
        self.calculateTestInterval  = [aDecoder decodeFloatForKey:@"calculate_test_interval"];
        self.calculateTestCorrect   = [aDecoder decodeIntegerForKey:@"calculate_test_correct"];
        self.calculateTestWrong     = [aDecoder decodeIntegerForKey:@"calculate_test_wrong"];
        self.examDate               = [aDecoder decodeObjectForKey:@"exam_date"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.estimateAge forKey:@"estimate_age"];
    [aCoder encodeInteger:self.bodyAge     forKey:@"body_age"];
    [aCoder encodeInteger:self.brainAge    forKey:@"brain_age"];
    [aCoder encodeFloat:self.balanceTestTiltSummary forKey:@"balance_test_tilt_summary"];
    [aCoder encodeFloat:self.calculateTestInterval forKey:@"calculate_test_interval"];
    [aCoder encodeInteger:self.calculateTestCorrect forKey:@"calculate_test_correct"];
    [aCoder encodeInteger:self.calculateTestWrong forKey:@"calculate_test_wrong"];
    [aCoder encodeObject:self.examDate forKey:@"exam_date"];
}

- (void)calculate
{
    // 脳年齢
    // 最小18歳。一問ミスごとに8歳加算。
    self.brainAge = 18 + (self.calculateTestWrong * 8);

    // (かかった秒数 - 問題数*2秒)の秒数加算
    NSInteger duration = + (self.calculateTestInterval - ((self.calculateTestCorrect + self.calculateTestWrong) * 2));
    if(duration > 0) {
        self.brainAge += duration;
    }
    
    self.brainAge = self.brainAge > 99 ? 99 : self.brainAge;

    // 肉体年齢
    // 最小18歳。5加算ごとに2歳プラス
    self.bodyAge = 18 + (self.balanceTestTiltSummary / 5);

    // 最大は99
    self.brainAge = self.brainAge > 99 ? 99 : self.brainAge;
    self.bodyAge = self.bodyAge > 99 ? 99 : self.bodyAge;

    // 推定年齢は平均
    self.estimateAge = (self.brainAge + self.bodyAge) / 2;
}

@end
