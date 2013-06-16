//
//  AEUserSettingViewController.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEDatePickerViewController.h"

@interface AEUserSettingViewController : UITableViewController <UITextFieldDelegate, AEDatePickerViewControllerDelegate>
@property (nonatomic, assign) IBOutlet UITextField *userNameField;
@property (nonatomic, assign) IBOutlet UITextField *birthdayField;
@property (nonatomic, assign) IBOutlet UITextField *prefectureField;
@property (nonatomic, assign) IBOutlet UIBarButtonItem *doneButton;
@property BOOL hideDoneButton;
@end
