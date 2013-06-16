//
//  AEBalanceTestViewController.m
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEBalanceTestViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "AETalk.h"
#import "AEEasyExamination.h"

#define CENTOR_TILT 0.05f
#define CIRCLE_SIZE_RATE 3.0f

#define AEBALANCETEST_TALK_TUTORIAL (@"あいふぉんを、すいへいにもって、まるをまんなかにあわせてね")
#define AEBALANCETEST_TALK_PLEASECENTER  (@"まんなかに、まるをあわせてね")
#define AEBALANCETEST_TALK_STANDBY  (@"めをとじて、かたあしをあげて、いまのしせいをほじしてね")
#define AEBALANCETEST_TALK_START    (@"そのまま、そのまま")
#define AEBALANCETEST_TALK_5SEC    (@"ごびょうけいか")
#define AEBALANCETEST_TALK_10SEC    (@"じゅうびょうたった")
#define AEBALANCETEST_TALK_END    (@"けいそくおわり")

@interface AEBalanceView : UIView
@property (nonatomic, retain) CMAttitude *attitude;
@end

@implementation AEBalanceView

- (void)setAttitude:(CMAttitude *)attitude
{
    _attitude = attitude;
    CGFloat roll = fabs(_attitude.roll);
    CGFloat pitch = fabs(_attitude.pitch);

    CGFloat tilt = roll > pitch ? roll : pitch;
    if(tilt <= CENTOR_TILT) {
        tilt = tilt / CENTOR_TILT;
        self.backgroundColor = [UIColor colorWithRed:.0 green:1.0-tilt blue:0.0 alpha:1.0f];
    } else {
        self.backgroundColor = [UIColor darkTextColor];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    
    
    CGSize circleSize = CGSizeMake(rect.size.width/CIRCLE_SIZE_RATE, rect.size.width/CIRCLE_SIZE_RATE);
    CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2);
    CGRect rollRect = CGRectMake(center.x + rect.size.width*self.attitude.roll - (circleSize.width/2),
                                 center.y - (circleSize.height/2),
                                 circleSize.width,
                                 circleSize.height);
    
    CGContextStrokeEllipseInRect(context, rollRect);

    CGRect pitchRect = CGRectMake(center.x - (circleSize.width/2),
                                 center.y + rect.size.height*self.attitude.pitch - (circleSize.height/2),
                                 circleSize.width,
                                 circleSize.height);
    
    CGContextStrokeEllipseInRect(context, pitchRect);
}

@end

@interface AEBalanceTestViewController ()
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@property (nonatomic, copy) void (^updateDeviceMotion)(CGFloat tilt, BOOL isCenter);
@property (nonatomic, retain) CMMotionManager *motionManager;
- (void)_startTesting;
- (void)_stopTesting;
@end

@implementation AEBalanceTestViewController

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
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 1.0f / 60.0f;
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _startTesting];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self _stopTesting];
    [self.operationQueue cancelAllOperations];
}

- (void)_startTesting
{
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        self.sensorLabel.text = [NSString stringWithFormat:@"(roll:%.3f, pitch:%.3f, yaw:%.3f)",
                                 motion.attitude.roll, motion.attitude.pitch, motion.attitude.yaw];
        [(AEBalanceView*)self.view setAttitude:motion.attitude];
        
        CGFloat roll = fabs(motion.attitude.roll);
        CGFloat pitch = fabs(motion.attitude.pitch);
        
        CGFloat tilt = roll > pitch ? roll : pitch;
        BOOL isCenter = tilt <= CENTOR_TILT;
        
        if(self.updateDeviceMotion) {
            self.updateDeviceMotion(tilt, isCenter);
        }
    }];

    [self.operationQueue addOperation:[self _setupOperation]];
}

- (void)_stopTesting
{
    [self.motionManager stopDeviceMotionUpdates];
}

#pragma mark - 計測オペレーション

- (NSOperation*)_setupOperation
{
    __block NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [AETalk talkSynchronousWithMessage:AEBALANCETEST_TALK_TUTORIAL];

        if(operation.isCancelled) { return; }
        
        [AETalk talkSynchronousWithMessage:AEBALANCETEST_TALK_STANDBY];
        [self.operationQueue addOperation:[self _standbyOperation]];
    }];
    return operation;
}

- (NSOperation*)_standbyOperation
{
    __block NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        if(operation.isCancelled) { return; }
        
        __block BOOL standbyComplete = YES;
        self.updateDeviceMotion = ^(CGFloat tilt, BOOL isCenter) {
            standbyComplete = isCenter;
        };
        
        // ３秒待つ
        NSDate *startDate = [NSDate date];
        while(standbyComplete) {
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
            if(interval > 3.0f) {
                break;
            }
            sleep(1);
        }
        
        self.updateDeviceMotion = nil;
        
        if(standbyComplete) {
            [self.operationQueue addOperation:[self _startTestOperation]];
        } else {
            [AETalk talkSynchronousWithMessage:AEBALANCETEST_TALK_PLEASECENTER];
           // やり直し
            [self.operationQueue addOperation:[self _standbyOperation]];
        }
        
                                    
    }];
    
    return operation;    
}

- (NSOperation*)_startTestOperation
{
    __block NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [AETalk talkSynchronousWithMessage:AEBALANCETEST_TALK_START];
        if(operation.isCancelled) {return;}
        
        __block CGFloat total = 0;
        self.updateDeviceMotion = ^(CGFloat tilt, BOOL isCenter) {
            total += tilt;
        };
        
        // 15秒計測
        NSDate *startDate = [NSDate date];
        while(YES) {
            if(operation.isCancelled) {return;}
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:startDate];
            if(5.0 <= interval && interval < 6.0f) {
                [AETalk talkSynchronousWithMessage:AEBALANCETEST_TALK_5SEC];
            }
            else if(10.0 <= interval && interval < 11.0f) {
                [AETalk talkSynchronousWithMessage:AEBALANCETEST_TALK_10SEC];
            }
            else if(interval > 15.0f) {
                break;
            }
            if(operation.isCancelled) {return;}
            sleep(1);
        }

        self.updateDeviceMotion = nil;

        [AETalk talkSynchronousWithMessage:AEBALANCETEST_TALK_END];
        
        // 結果を格納
        [AEEasyExamination sharedObject].result.balanceTestTiltSummary = total;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"CalculateTest" sender:self];
        });
    }];
    return operation;
}

@end
