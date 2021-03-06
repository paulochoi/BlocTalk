//
//  AppDelegate.m
//  BlocTalk
//
//  Created by Paulo Choi on 9/22/15.
//  Copyright (c) 2015 Paulo Choi. All rights reserved.
//

#import "AppDelegate.h"
#import "MultiConnectivityManager.h"

@interface AppDelegate ()

//@property (nonatomic, strong) MultiConnectivityManager *mcManager;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //self.mcManager = [[MultiConnectivityManager alloc] init];
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"UUID"]){
        NSString *UUID = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:UUID forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"UserDisplayName"]){
        NSString *displayName = [[UIDevice currentDevice] name];
        [[NSUserDefaults standardUserDefaults] setObject:displayName forKey:@"UserDisplayName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //creates archive folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    self.archiveFolder = [documentsDirectory stringByAppendingPathComponent:@"archiveFolder"];
    NSString *avatars = [documentsDirectory stringByAppendingPathComponent:@"avatars"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.archiveFolder]) {
        NSError *error = nil;
        //NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
        //                                                forKey:NSFileProtectionKey];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:self.archiveFolder
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:avatars]) {
        NSError *error = nil;
        //NSDictionary *attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
        //                                                forKey:NSFileProtectionKey];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:avatars
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        if (error)
            NSLog(@"Error creating directory path: %@", [error localizedDescription]);
    }
    
    //register for notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"notification");
    
    
}


@end
