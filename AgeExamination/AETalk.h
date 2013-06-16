//
//  AETalk.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AETalk : NSObject
+ (void)talkSynchronousWithMessage:(NSString*)message;
+ (void)talkAsynchronousWithMessage:(NSString*)message;
@end
