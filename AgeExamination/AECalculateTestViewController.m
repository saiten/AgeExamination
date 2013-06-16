//
//  AECalculateTestViewController.m
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AECalculateTestViewController.h"
#import "AETalk.h"
#import "ZinniaResult.h"
#import "AECalculateCell.h"
#import "AEEasyExamination.h"
#import <MACircleProgressIndicator.h>

#define EXAM_COUNT (20)
#define LIMIT_TIME (5.0f)
#define TIMER_INTERVAL (0.1f)

@interface AECalculateTestViewController ()
@property (nonatomic, retain) NSArray *exams;
@property (nonatomic, retain) MACircleProgressIndicator *timerIndicator;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, retain) NSDate *startDate;
@end

@implementation AECalculateTestViewController

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
	// Do any additional setup after loading the view.
    self.exams = [self _generateCalculateExamWithLimit:EXAM_COUNT];

    self.timerIndicator = [[MACircleProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
    self.timerIndicator.value = 0.0f;
    [self.view addSubview:self.timerIndicator];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.startDate = [NSDate date];
    [self _nextExamWithIndex:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)_generateCalculateExamWithLimit:(NSUInteger)limit;
{
    NSMutableArray *exams = [NSMutableArray arrayWithCapacity:limit];
    while(exams.count < limit) {
        AECalculateOperator op = arc4random() % AECalculateOperatorSize;
        NSUInteger leftLimit = (op == AECalculateOperatorMultiple) ? 15 : 40;
        NSUInteger rightLimit = (op == AECalculateOperatorMultiple || op == AECalculateOperatorDivision) ? 15 : 40;
        AECalculateExam *exam = [AECalculateExam calculateExamWithOperator:op leftLimit:leftLimit rightLimit:rightLimit];
        
        // 問題の答えは2桁まで
        if(exam.answer > 99) {
            continue;
        }
        NSLog(@"%@", exam.description);
        [exams addObject:exam];
    }
    
    return exams;
}

- (NSInteger)correctCount
{
    NSInteger count = 0;
    for(AECalculateExam *exam in self.exams) {
        if(exam.status == AECalculateStatusCorrect) {
            count++;
        }
    }
    return count;
}

- (NSInteger)wrongCount
{
    NSInteger count = 0;
    for(AECalculateExam *exam in self.exams) {
        if(exam.status == AECalculateStatusWrong) {
            count++;
        }
    }
    return count;
}

- (NSInteger)examCount
{
    return self.exams.count;
}

#pragma mark - event handler

- (void)pressedClearButton:(id)sender
{
    [self.canvasView clear];
}

#pragma mark - UITableView delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.exams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CalculateCell";
    AECalculateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.exam = [self.exams objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - AECanvasViewDelegate

- (void)canvasView:(AECanvasView *)canvasView strokesEnded:(NSArray *)results
{
    NSInteger index = [[self.tableView indexPathForSelectedRow] row];
    AECalculateExam *exam = [self.exams objectAtIndex:index];
    
    if(results && results.count > 0) {
        for(ZinniaResult *result in results) {
            NSLog(@"input : %@ (%f)", result.value, [result.score floatValue]);
            if(exam.answer == [result.value integerValue]) {
                [self _correctExamWithIndex:index];
                break;
            }
        }
    }
}

#pragma mark - private methods

- (void)_correctExamWithIndex:(NSInteger)index
{
    NSArray *talks = @[@"せいかい", @"すげー", @"さすが", @"しびれる", @"やたー", @"かこいい"];
    NSString *talk = [talks objectAtIndex:rand() % talks.count];
    [AETalk talkAsynchronousWithMessage:talk];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AECalculateExam *exam = [self.exams objectAtIndex:index];
        exam.status = AECalculateStatusCorrect;

        [self _nextExamWithIndex:index+1];
    });
}

- (void)_wrongExamWithIndex:(NSInteger)index
{
    NSArray *talks = @[@"え", @"そんな", @"ひどい", @"ずこー", @"うげー", @"ぎゃー"];
    NSString *talk = [talks objectAtIndex:rand() % talks.count];
    [AETalk talkAsynchronousWithMessage:talk];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        AECalculateExam *exam = [self.exams objectAtIndex:index];
        exam.status = AECalculateStatusWrong;

        [self _nextExamWithIndex:index+1];
    });
}

- (void)_nextExamWithIndex:(NSInteger)index
{
    NSInteger restCount = self.examCount - self.correctCount - self.wrongCount;
    if(restCount > 0) {
        self.timerIndicator.value = 0.0f;        
        [self.timer invalidate];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                      target:self
                                                    selector:@selector(doTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionTop];
        [self.canvasView clear];
        self.title = [NSString stringWithFormat:@"計算中...(残り%d問)", restCount];
    } else {
        [self.timer invalidate];
        
        // 結果を格納
        AEEasyResult * result = [AEEasyExamination sharedObject].result;
        result.calculateTestCorrect = self.correctCount;
        result.calculateTestWrong = self.wrongCount;
        result.calculateTestInterval = -[self.startDate timeIntervalSinceNow];
        
        // 結果画面へ
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(1);
            [AETalk talkSynchronousWithMessage:@"おつかれさまでした"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"result" sender:self];
            });
        });
    }
}


- (void)doTimer:(id)sender
{
    CGFloat increase = TIMER_INTERVAL / LIMIT_TIME;
    // 時間切れ
    if(self.timerIndicator.value + increase > 1.0f) {
        [self.timer invalidate];
        [self _wrongExamWithIndex:[[self.tableView indexPathForSelectedRow] row]];
    } else {
        self.timerIndicator.value += increase;
    }
}

@end
