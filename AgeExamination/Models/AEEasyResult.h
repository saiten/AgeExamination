//
//  AEEasyResult.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Util.h"

@class AEEasyResult;

@interface AEEasyResultManager : NSObject
@property (nonatomic, retain) NSMutableArray *results;

+ (instancetype)sharedManager;

- (AEEasyResult*)resultForDate:(NSDate*)date;
- (void)setResult:(AEEasyResult*)result;
- (void)removeResult:(AEEasyResult*)result;
- (NSArray*)resultsWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
- (void)removeAllResults;
@end

@interface AEEasyResult : NSObject <NSCoding>
@property NSInteger                  estimateAge;
@property NSInteger                  bodyAge;
@property NSInteger                  brainAge;
@property CGFloat                    balanceTestTiltSummary;
@property NSTimeInterval             calculateTestInterval;
@property NSInteger                  calculateTestCorrect;
@property NSInteger                  calculateTestWrong;
@property (nonatomic, retain) NSDate *examDate;

- (void)calculate;
@end
