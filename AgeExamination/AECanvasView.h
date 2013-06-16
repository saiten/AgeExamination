//
//  AECanvasView.h
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AECanvasViewDelegate;

@interface AECanvasView : UIView
@property (nonatomic, retain) NSMutableArray *strokes;
@property (nonatomic, retain) NSMutableArray *points;
@property CGPoint touchPoint;
@property (nonatomic, assign) IBOutlet NSObject<AECanvasViewDelegate> *delegate;

- (void)clear;
@end

@protocol AECanvasViewDelegate
- (void)canvasView:(AECanvasView*)canvasView strokesEnded:(NSArray*)results;
@end
