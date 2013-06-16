//
//  AESettingViewController.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AESettingViewController.h"
#import "AEUserSettingViewController.h"
#import "AEEasyResult.h"

@interface AESettingViewController ()

@end

@implementation AESettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)pressedCloseButton:(id)sender
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"UserSetting"]) {
        AEUserSettingViewController *viewController = [segue destinationViewController];
        viewController.hideDoneButton = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"データ消去"
                                                            message:@"本当によろしいですか？"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[AEEasyResultManager sharedManager] removeAllResults];
    
    UIAlertView *resultView = [[UIAlertView alloc] initWithTitle:@"完了"
                                                         message:@"データを消去しました"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
    [resultView show];
}

@end
