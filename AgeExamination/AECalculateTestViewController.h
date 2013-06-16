//
//  AECalculateTestViewController.h
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AECanvasView.h"

@interface AECalculateTestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AECanvasViewDelegate>
@property (nonatomic, readonly) NSInteger examCount;
@property (nonatomic, readonly) NSInteger correctCount;
@property (nonatomic, readonly) NSInteger wrongCount;

@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet AECanvasView *canvasView;
- (IBAction)pressedClearButton:(id)sender;
@end
