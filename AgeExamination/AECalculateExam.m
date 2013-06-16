//
//  AECalculateExam.m
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AECalculateExam.h"

@implementation AECalculateExam

+ (instancetype)calculateExamWithOperator:(AECalculateOperator)op leftLimit:(NSUInteger)leftLimit rightLimit:(NSUInteger)rightLimit
{
    AECalculateExam *exam = [[AECalculateExam alloc] init];
    
    exam.status = AECalculateStatusUnsolved;
    exam.left = (arc4random() % (leftLimit-1)) + 1;
    exam.right = (arc4random() % (rightLimit-1)) + 1;
    exam.op = op;
    
    switch (op) {
        case AECalculateOperatorAddition:
        {
            exam.answer = exam.left + exam.right;
            break;
        }
        case AECalculateOperatorSubtraction:
        {
            NSInteger answer = exam.left - exam.right;
            while(answer < 0) {
                exam.left = (arc4random() % (leftLimit-1)) + 1;
                exam.right = (arc4random() % (rightLimit-1)) + 1;
                answer = exam.left - exam.right;
            }
            exam.answer = answer;
            break;
        }
        case AECalculateOperatorMultiple:
        {
            exam.answer = exam.left * exam.right;
            break;
        }
        case AECalculateOperatorDivision:
        {
            // leftの約数でrightLimitに収まる値を求める
            while(YES) {
                NSMutableArray *divisors = [NSMutableArray array];
                
                for(int i = 1; i < exam.left || i < rightLimit; i++) {
                    if(exam.left % i == 0) {
                        [divisors addObject:[NSNumber numberWithInt:i]];
                    }
                }
                
                // 1以外の約数がないとダメ
                if(exam.left != 0 && divisors.count > 2) {
                    NSNumber *right = [divisors objectAtIndex:arc4random()%divisors.count];
                    exam.right = [right integerValue];
                    exam.answer = exam.left / exam.right;
                    break;
                }
                
                // やり直し
                exam.left = (arc4random() % (leftLimit-1)) + 1;
            }
            break;
        }
        default:
            break;
    }
    
    return exam;
}

- (NSString *)calculateExamStringWithAnswerHidden:(BOOL)answerHidden
{
    NSString *opStr = nil;
    switch(self.op) {
        case AECalculateOperatorAddition:    opStr = @"＋"; break;
        case AECalculateOperatorSubtraction: opStr = @"ー"; break;
        case AECalculateOperatorMultiple:    opStr = @"×"; break;
        case AECalculateOperatorDivision:    opStr = @"÷"; break;
        default: opStr = @"?"; break;
    }
    
    if(answerHidden) {
        return [NSString stringWithFormat:@"%d%@%d=□", self.left, opStr, self.right];
    } else {
        return [NSString stringWithFormat:@"%d%@%d=%d", self.left, opStr, self.right, self.answer];
    }
}

- (NSString *)description
{
    return [self calculateExamStringWithAnswerHidden:NO];
}

@end
