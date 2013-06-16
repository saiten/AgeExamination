//
//  AEMainViewController.h
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary.h>

@interface AEMainViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>
@property (nonatomic, retain) TKCalendarMonthView *calendarView;
@property (nonatomic, assign) IBOutlet UIButton *examinationButton;
@property (nonatomic, assign) IBOutlet UIView *detailContainerView;
@property (nonatomic, assign) IBOutlet UILabel *estimateAgeLabel;
@property (nonatomic, assign) IBOutlet UILabel *bodyAgeLabel;
@property (nonatomic, assign) IBOutlet UILabel *brainAgeLabel;
@property (nonatomic, assign) IBOutlet UIImageView *clearedImageView;

@end
