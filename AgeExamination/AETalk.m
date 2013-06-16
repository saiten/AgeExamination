//
//  AETalk.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AETalk.h"
#import "AquesTalk_iPhone.h"

@implementation AETalk

+ (void)talkSynchronousWithMessage:(NSString *)message
{
    const char *talk = [message cStringUsingEncoding:NSShiftJISStringEncoding];
    AquesTalkDa_PlaySync(talk, 100);
}

+ (void)talkAsynchronousWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self talkSynchronousWithMessage:message];
    });
}

@end
