//
//  AEResultViewController.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEResultViewController.h"
#import "AEEasyExamination.h"
#import "AETalk.h"
#import "AEEasyUser.h"
#import <SHK.h>

@interface AEResultViewController ()
@property BOOL annnounced;
@end

@implementation AEResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.estimateAgeLabel.hidden = YES;
    self.brainAgeLabel.hidden = YES;
    self.bodyAgeLabel.hidden = YES;
    self.doneButton.enabled = NO;
    self.annnounced = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.annnounced) {
        [self _announceResult];
        self.annnounced = YES;
    }
}

- (void)_announceResult
{
    NSArray *numTalks = @[@"", @"いち", @"にい", @"さん", @"よん", @"ご", @"ろく", @"なな", @"はち", @"きゅう"];
    NSString *tenTalk = @"じゅう";
    
    AEEasyResult * result = [AEEasyExamination sharedObject].result;
    [result calculate];
    [[AEEasyResultManager sharedManager] setResult:result];
    
    self.estimateAgeLabel.text = [NSString stringWithFormat:@"%d", result.estimateAge];
    self.bodyAgeLabel.text = [NSString stringWithFormat:@"%d", result.bodyAge];
    self.brainAgeLabel.text = [NSString stringWithFormat:@"%d", result.brainAge];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [AETalk talkSynchronousWithMessage:@"あなたのねんれいわ"];
        sleep(2);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.estimateAgeLabel.hidden = NO;
            self.brainAgeLabel.hidden = NO;
            self.bodyAgeLabel.hidden = NO;
        });

        NSString *ageTalk = [NSString stringWithFormat:@"%@%@%@", [numTalks objectAtIndex:result.estimateAge / 10], tenTalk, [numTalks objectAtIndex:result.estimateAge % 10]];
        [AETalk talkSynchronousWithMessage:[NSString stringWithFormat:@"すいてい、%@さいです", ageTalk]];
        
        sleep(1);

        // 評価
        AEEasyUser *user = [AEEasyUser loadUser];
        NSInteger diff = [user.birthDay age] - result.estimateAge;
        if(diff > 5) {
            [AETalk talkSynchronousWithMessage:@"わかいですね。このちょうしでがんばりましょう"];
        }
        else if(-5 <= diff && diff <= 5) {
            [AETalk talkSynchronousWithMessage:@"としそうおうですね。まだまだやれるはずです"];
        }
        else {
            [AETalk talkSynchronousWithMessage:@"むー、もっとがんばりましょう"];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self.doneButton.enabled = YES;
        });
    });
}

- (void)pressedDoneButton:(id)sender
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction)pressedShareButton:(id)sender
{
    AEEasyResult * result = [AEEasyExamination sharedObject].result;
    NSString *message = [NSString stringWithFormat:@"今日の体内年齢は%d歳、脳年齢は%d歳、推定年齢は%d歳でした。", result.bodyAge, result.brainAge, result.estimateAge];
    
    SHKItem *item = [SHKItem text:message];
    [[SHKActionSheet actionSheetForItem:item] showInView:[[UIApplication sharedApplication] keyWindow]];
}

@end
