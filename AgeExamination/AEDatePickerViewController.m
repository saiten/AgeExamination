//
//  AEDatePickerViewController.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEDatePickerViewController.h"

@interface AEDatePickerViewController ()

@end

@implementation AEDatePickerViewController


- (IBAction)pressedDoneButton:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didDoneButtonClicked:selectedDate:)]) {
        [self.delegate didDoneButtonClicked:self selectedDate:self.datePicker.date];
    }
}

- (IBAction)pressedCancelButton:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didCancelButtonClicked:)]) {
        [self.delegate didCancelButtonClicked:self];
    }
}


@end
