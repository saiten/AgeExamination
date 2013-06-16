//
//  AEEasyExamination.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AEEasyResult.h"

@interface AEEasyExamination : NSObject
@property (nonatomic, retain) AEEasyResult *result;
+ (instancetype)sharedObject;
@end
