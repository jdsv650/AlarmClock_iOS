//
//  MMAppDelegate.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "MMAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface MMAppDelegate ()
{
    AVAudioPlayer *player;
}
@end


@implementation MMAppDelegate


//  [NSDate dateWithTimeIntervalSince1970: timeInterval] -- if primitives checked when gen

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.alertBody = @"Local Notification Body : Some Alert";
    localNotification.alertAction = @"Action String";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    if([player isPlaying])
        [player stop];
    
    return YES;

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
        
    //    application.applicationIconBadgeNumber = 0;
    
     //   NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Car_Alarm.mp3", [[NSBundle mainBundle] resourcePath]]];
        
//        NSError *error;
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        player.numberOfLoops = -1;
//        
//        if (player == nil)
//            NSLog(@"%@", [error description]);
//        else
//            [player play];
//        
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //
    NSString *soundFileString = [NSString stringWithFormat:@"%@/silence_10.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL URLWithString:soundFileString];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.volume = 0.5;
    player.numberOfLoops = -1; //keep playing
    [player play];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
