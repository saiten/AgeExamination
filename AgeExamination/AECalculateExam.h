//
//  AECalculateExam.h
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AECalculateStatusUnsolved,
    AECalculateStatusCorrect,
    AECalculateStatusWrong
} AECalculateStatus;


typedef enum {
    AECalculateOperatorAddition,
    AECalculateOperatorSubtraction,
    AECalculateOperatorMultiple,
    AECalculateOperatorDivision,
    AECalculateOperatorSize
} AECalculateOperator;

@interface AECalculateExam : NSObject

@property AECalculateStatus status;
@property NSUInteger right;
@property NSUInteger left;
@property AECalculateOperator op;
@property NSUInteger answer;

+ (instancetype)calculateExamWithOperator:(AECalculateOperator)op
                                leftLimit:(NSUInteger)leftLimit
                               rightLimit:(NSUInteger)rightLimit;

- (NSString *)calculateExamStringWithAnswerHidden:(BOOL)answerHidden;
@end
