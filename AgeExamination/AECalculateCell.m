//
//  AECalculateCell.m
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AECalculateCell.h"

@implementation AECalculateCell

- (void)_updateView
{
    switch (self.exam.status) {
        case AECalculateStatusUnsolved:
            self.examLabel.text = [self.exam calculateExamStringWithAnswerHidden:YES];
            self.correctImageView.hidden = YES;
            self.wrongImageView.hidden = YES;
            break;
        case AECalculateStatusCorrect:
            self.examLabel.text = [self.exam calculateExamStringWithAnswerHidden:NO];
            self.correctImageView.hidden = NO;
            self.wrongImageView.hidden = YES;
            break;
        case AECalculateStatusWrong:
            self.examLabel.text = [self.exam calculateExamStringWithAnswerHidden:NO];
            self.correctImageView.hidden = YES;
            self.wrongImageView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setExam:(AECalculateExam *)exam
{
    [_exam removeObserver:self forKeyPath:@"status"];
    _exam = exam;
    [_exam addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    [self _updateView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self _updateView];
}

@end

