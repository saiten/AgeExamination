//
//  AEResultViewController.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEResultViewController : UIViewController
@property (nonatomic, assign) IBOutlet UILabel *estimateAgeLabel;
@property (nonatomic, assign) IBOutlet UILabel *bodyAgeLabel;
@property (nonatomic, assign) IBOutlet UILabel *brainAgeLabel;
@property (nonatomic, assign) IBOutlet UIButton *doneButton;
- (IBAction)pressedDoneButton:(id)sender;
@end
