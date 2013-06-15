//
//  AEAppDelegate.m
//  AgeExamination
//
//  Created by saiten on 2013/06/15.
//  Copyright (c) 2013年 saiten. All rights reserved.
//

#import "AEAppDelegate.h"
#import "AEUser.h"

@implementation AEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"AgeExamination.sqlite"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    [self.managedObjectContext saveToPersistentStoreAndWait];
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    return [NSManagedObjectContext defaultContext];
}

- (NSManagedObjectModel *)managedObjectModel
{
    return [NSManagedObjectModel defaultManagedObjectModel];
}

@end
