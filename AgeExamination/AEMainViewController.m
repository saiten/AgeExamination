//
//  AEMainViewController.m
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEMainViewController.h"
#import "AEEasyUser.h"
#import "AEEasyExamination.h"
#import "AEEasyResult.h"

@interface AEMainViewController ()

@end

@implementation AEMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.calendarView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:YES
                                                                  timeZone:[NSTimeZone timeZoneWithName:@"Asia/Tokyo"]];
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    [self.view addSubview:self.calendarView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AEEasyUser *user = [AEEasyUser loadUser];
    if(!user) {
        [self performSegueWithIdentifier:@"UserSetting" sender:self];
    } else {
        // 一日1回
        NSDate *today = [[NSDate date] adjustZeroClockDate];
        AEEasyResult *result = [[AEEasyResultManager sharedManager] resultForDate:today];
        if(result) {
            [self.examinationButton setTitle:@"測定済み" forState:UIControlStateNormal];
            self.examinationButton.enabled = NO;
        } else {
            [self.examinationButton setTitle:@"測定" forState:UIControlStateNormal];
            self.examinationButton.enabled = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.calendarView reloadData];
    [self.calendarView selectDate:[NSDate date]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 初期化しとく
    if([segue.identifier isEqualToString:@"UserSetting"]) {
        AEEasyUser *user = [[AEEasyUser alloc] init];
        user.name = @"名無しさん";
        user.birthDay = [NSDate date];
        user.prefecture = @"東京都";
        [user save];
    }
    // 診断の初期化
    else if([segue.identifier isEqualToString:@"Examination"]) {
        AEEasyResult *result = [[AEEasyResult alloc] init];
        result.examDate = [[NSDate date] adjustZeroClockDate];
        
        [AEEasyExamination sharedObject].result = result;
    }
}

#pragma mark - calendarview delegate

- (NSArray *)calendarContainerViewAtIndexes:(NSIndexSet *)indexes
{
    return [NSArray array];
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)date
{
    AEEasyResult *result = [[AEEasyResultManager sharedManager] resultForDate:date];
    if(result) {
        self.estimateAgeLabel.text = [NSString stringWithFormat:@"%d", result.estimateAge];
        self.bodyAgeLabel.text = [NSString stringWithFormat:@"%d", result.bodyAge];
        self.brainAgeLabel.text = [NSString stringWithFormat:@"%d", result.brainAge];
        self.detailContainerView.hidden = NO;
        self.clearedImageView.hidden = NO;
    } else {
        self.detailContainerView.hidden = YES;
        self.clearedImageView.hidden = YES;
    }
    if([[date adjustZeroClockDate] compare:[[NSDate date] adjustZeroClockDate]] == NSOrderedSame) {
        self.examinationButton.hidden = NO;
    } else {
        self.examinationButton.hidden = YES;
    }
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)month animated:(BOOL)animated
{
}

- (BOOL)calendarMonthView:(TKCalendarMonthView *)monthView monthShouldChange:(NSDate *)month animated:(BOOL)animated
{
    return YES;
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthWillChange:(NSDate *)month animated:(BOOL)animated
{
}

#pragma mark - calendar datasource

- (NSArray *)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate
{
	NSMutableArray *marks = [NSMutableArray array];
	
	NSDate *date = startDate;
	while (YES) {
		// 終了判定
		if ([date compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
        AEEasyResult *result = [[AEEasyResultManager sharedManager] resultForDate:date];
		// メモがある場合にはYESを、無い場合にはNOをセットする
		if (result) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// 日付を1日すすめる
        date = [date nextDate];
	}
	
	return marks;
}

@end
