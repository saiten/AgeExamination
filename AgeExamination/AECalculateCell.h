//
//  AECalculateCell.h
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AECalculateExam.h"

@interface AECalculateCell : UITableViewCell
@property (nonatomic, assign) IBOutlet UILabel *examLabel;
@property (nonatomic, assign) IBOutlet UIImageView *correctImageView;
@property (nonatomic, assign) IBOutlet UIImageView *wrongImageView;
@property (nonatomic, retain) AECalculateExam *exam;
@end

