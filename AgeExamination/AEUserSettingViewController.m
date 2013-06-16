//
//  AEUserSettingViewController.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEUserSettingViewController.h"
#import "AEEasyUser.h"

@interface AEUserSettingViewController ()
@property (nonatomic, retain) AEDatePickerViewController *datePickerViewController;
@end

@implementation AEUserSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.userNameField.delegate = self;
    self.birthdayField.delegate = self;
    self.prefectureField.delegate = self;
    
    AEEasyUser *user = [AEEasyUser loadUser];
    self.userNameField.text = user.name;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.birthdayField.text = [formatter stringFromDate:user.birthDay];
    
    self.prefectureField.text = user.prefecture;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(self.hideDoneButton) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    AEEasyUser *user = [AEEasyUser loadUser];
    user.name = self.userNameField.text;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    user.birthDay = [formatter dateFromString:self.birthdayField.text];
    
    user.prefecture = self.prefectureField.text;

    [user save];
}

- (IBAction)pressedDoneButton:(id)sender
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.userNameField || textField == self.prefectureField) {
        [self hideModal:self.datePickerViewController.view];
        self.datePickerViewController.delegate = nil;
    } else {
        [self.userNameField resignFirstResponder];
        [self.prefectureField resignFirstResponder];
        
        if(!self.datePickerViewController) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AgeExamination" bundle:nil];
            self.datePickerViewController = [storyboard instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
            self.datePickerViewController.delegate = self;
            [self showModal:self.datePickerViewController.view];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - AEDatePicker

- (void)didDoneButtonClicked:(AEDatePickerViewController *)controller selectedDate:(NSDate *)selectedDate
{
    [self hideModal:controller.view];
    self.datePickerViewController = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.birthdayField.text = [formatter stringFromDate:selectedDate];
}

- (void)didCancelButtonClicked:(AEDatePickerViewController *)controller
{
    [self hideModal:controller.view];
    self.datePickerViewController = nil;
}


#pragma mark - date picker

- (void) showModal:(UIView *) modalView
{
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    modalView.center = offScreenCenter;
    
    UIWindow *window = self.view.window;
    [window addSubview:modalView];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    modalView.center = middleCenter;
    [UIView commitAnimations];
}

- (void) hideModal:(UIView*) modalView
{
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width * 0.5f, offSize.height * 1.5f);
    [UIView beginAnimations:nil context:(__bridge_retained void *)(modalView)];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
    modalView.center = offScreenCenter;
    [UIView commitAnimations];
}

- (void) hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIView *modalView = (__bridge_transfer UIView *)context;
    [modalView removeFromSuperview];
    
    self.datePickerViewController = nil;
}


@end
