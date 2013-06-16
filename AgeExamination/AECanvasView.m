//
//  AECanvasView.m
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AECanvasView.h"
#import "ZinniaRecognizer.h"

@interface AECanvasView ()
@property (nonatomic, retain) ZinniaRecognizer *recognizer;
@property (nonatomic, retain) NSOperationQueue *operationQueue;
@end

@implementation AECanvasView

- (void)awakeFromNib
{
    self.strokes = [NSMutableArray array];
    
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"number" ofType:@"model"];
    self.recognizer = [[ZinniaRecognizer alloc] initWithModelFilePath:modelPath];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    
}

- (void)dealloc
{
    [self.operationQueue cancelAllOperations];
}

- (void)drawStroke:(NSArray*)stroke
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 2.0f);
    
    if(stroke.count == 1) {
        CGPoint point = [[stroke objectAtIndex:0] CGPointValue];
        CGContextFillRect(context, CGRectMake(point.x, point.y, 2.0f, 2.0f));
    } else {
        CGPoint points[stroke.count];
        for(int i = 0; i < stroke.count; i++) {
            points[i] = [[stroke objectAtIndex:i] CGPointValue];
        }
        CGContextMoveToPoint(context, points[0].x, points[0].y);
        CGContextAddLines(context, points, stroke.count);
        CGContextStrokePath(context);
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.recognizer.size = frame.size;
}

- (void)clear
{
    [self.operationQueue cancelAllOperations];
    [self.recognizer clear];
    
    [self.strokes removeAllObjects];
    [self.points removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    for(NSArray *stroke in self.strokes) {
        [self drawStroke:stroke];
    }
    [self drawStroke:self.points];
}


#pragma mark - touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.points = [NSMutableArray array];
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:self];
    
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if(!CGRectContainsPoint(rect, self.touchPoint)) {
        return;
    }
    
    [self.points addObject:[NSValue valueWithCGPoint:self.touchPoint]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    if(!CGRectContainsPoint(rect, currentPoint)) {
        return;
    }
    
    [self.points addObject:[NSValue valueWithCGPoint:currentPoint]];
    self.touchPoint = currentPoint;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.points.count == 0) {
        return;
    }
    
    [self.strokes addObject:self.points];
    
    [self.operationQueue addOperationWithBlock:^{
//        // y座標反転
//        NSMutableArray *reversePoints = [NSMutableArray arrayWithCapacity:self.points.count];
//        for(NSValue *pointValue in self.points) {
//            CGPoint point = [pointValue CGPointValue];
//            point.y = self.bounds.size.height - point.y;
//            [reversePoints addObject:[NSValue valueWithCGPoint:point]];
//        }
        
        NSArray * results = [_recognizer classify:self.points];
        
        if(results) {
            if(self.delegate && [self.delegate respondsToSelector:@selector(canvasView:strokesEnded:)]) {
                [self.delegate canvasView:self strokesEnded:results];
            }
        }
    }];

    [self setNeedsDisplay];
}

@end
