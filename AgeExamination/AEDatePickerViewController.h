//
//  AEDatePickerViewController.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AEDatePickerViewControllerDelegate;

@interface AEDatePickerViewController : UIViewController
@property (nonatomic, assign) NSObject<AEDatePickerViewControllerDelegate> *delegate;
@property (nonatomic, assign) IBOutlet UIDatePicker *datePicker;
@end

@protocol AEDatePickerViewControllerDelegate
- (void)didDoneButtonClicked:(AEDatePickerViewController *)controller selectedDate:(NSDate *)selectedDate;
- (void)didCancelButtonClicked:(AEDatePickerViewController *)controller;
@end