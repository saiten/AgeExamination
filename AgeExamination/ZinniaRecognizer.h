//
//  ZinniaRecognizer.h
//  iBrainAge
//
//  Created by saiten on 2013/01/05.
//
//

#import <Foundation/Foundation.h>
#import "ZinniaResult.h"

@interface ZinniaRecognizer : NSObject
@property (readwrite) CGSize size;
@property (readwrite) NSUInteger separateStorokeCount;

- (id)initWithModelFilePath:(NSString*)path;
- (NSArray*)classify:(NSArray*)points;
- (NSArray*)classifyCharactersWithStrokes:(NSArray *)strokes;
- (NSArray*)classifyCharacterWithStrokes:(NSArray *)strokes;
- (void)clear;

@end
