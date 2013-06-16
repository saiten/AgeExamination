//
//  AEShareKitConfigurator.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEShareKitConfigurator.h"

@implementation AEShareKitConfigurator

- (NSString *)appName
{
    return @"みんなの年齢診断";
}

- (NSString *)appURL
{
    return @"http://saiten.co/";
}

- (NSNumber *)isUsingCocoaPods
{
    return [NSNumber numberWithBool:YES];
}


@end
