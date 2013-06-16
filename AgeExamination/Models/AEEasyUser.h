//
//  AEEasyUser.h
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AEEasyUser : NSObject <NSCoding>
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *prefecture;
@property (nonatomic, retain) NSDate *birthDay;

+ (AEEasyUser*)loadUser;
- (void)save;
@end
