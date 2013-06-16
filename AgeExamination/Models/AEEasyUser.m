//
//  AEEasyUser.m
//  AgeExamination
//
//  Created by saiten on 2013/06/16.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEEasyUser.h"

@implementation AEEasyUser

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        self.name       = [aDecoder decodeObjectForKey:@"user"];
        self.prefecture = [aDecoder decodeObjectForKey:@"prefecture"];
        self.birthDay   = [aDecoder decodeObjectForKey:@"birth_day"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"user"];
    [aCoder encodeObject:self.prefecture forKey:@"prefecture"];
    [aCoder encodeObject:self.birthDay forKey:@"birth_day"];
}

+ (AEEasyUser*)loadUser
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
    AEEasyUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return user;
}


- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"current_user"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
