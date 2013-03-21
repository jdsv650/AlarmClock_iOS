//
//  MMAppDelegate.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "MMAppDelegate.h"
#import "MMAlarmMainViewController.h"
#import "MMAlarmDetails.h"  
#import <AVFoundation/AVFoundation.h>

@interface MMAppDelegate ()
{
    AVAudioPlayer *player;
    MMAlarmMainViewController *mainViewController;
}
@end


@implementation MMAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize alarms;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"applcationdidFinishLaunchingWithOptions");
    mainViewController = (MMAlarmMainViewController *)self.window.rootViewController;
    
    if(!alarms) {
        NSLog(@"alarms == nil alloc new array");
        alarms = [[NSMutableArray alloc] init];
    }
    
    // for background
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
//    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60];
//    localNotification.soundName = UILocalNotificationDefaultSoundName;
//    localNotification.alertBody = @"Local Notification Body : Some Alert";
//    localNotification.alertAction = @"Action String";
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    if([player isPlaying])
        [player stop];
    
    return YES;
}


-(void) fetchAlarms
{
    //empty and rebuild alarms array
    if(alarms.count >= 1)
    {
        [alarms removeAllObjects];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AlarmDetails"
                                          inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSLog(@"IN buildAlarms");
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"alarmDateTime" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        // Handle the error
        NSLog(@"Error - Fetched Objects = nil");
    }
    
    for(NSManagedObject *mObj in fetchedObjects)
    {
        NSLog(@"NEXT Managed Object has values == ");
        NSLog(@"%@",[mObj valueForKey:@"alarmDateTime"]);
        NSLog(@"%@",[mObj valueForKey:@"isSnoozeEnabled"]);
        
        MMAlarmDetails *nextAlarm = [[MMAlarmDetails alloc] init];
        nextAlarm.alarmDateTime = [mObj valueForKey:@"alarmDateTime"];
        nextAlarm.alarmMessage = [mObj valueForKey:@"alarmMessage"];
        nextAlarm.alarmSound = [mObj valueForKey:@"alarmSound"];
        nextAlarm.alarmVolume = [[mObj valueForKey:@"alarmVolume"] floatValue];
        nextAlarm.snoozeDuration = [[mObj valueForKey:@"snoozeDuration"] intValue];
        nextAlarm.isSnoozeEnabled = [[mObj valueForKey:@"isSnoozeEnabled"] boolValue];
        nextAlarm.isSetToVibrate = [[mObj valueForKey:@"isSetToVibrate"]boolValue];
        nextAlarm.isSetToFlash = [[mObj valueForKey:@"isSetToFlash"] boolValue];
        [alarms addObject:nextAlarm];
    }
    
    //build this instead -->see above 
    //alarms = [NSMutableArray arrayWithArray:fetchedObjects];
    
    //setup alarms array in the main view controller
    mainViewController.alarms = alarms;
    
    //empty database
    for(NSManagedObject *mObj in fetchedObjects)
    {
        [[self managedObjectContext] deleteObject:mObj];
    }
    
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
    
    //save data
    
    NSLog(@"applicationDidEnterBackground");
    
    [self saveAlarms];
    
    NSString *soundFileString = [NSString stringWithFormat:@"%@/silence_10.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL URLWithString:soundFileString];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.volume = 0.5;
    player.numberOfLoops = -1; //keep playing
    [player play];
    
}

- (void)saveAlarms
{
    for(int i=0; i < alarms.count; i++)
    {
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"AlarmDetails"
                                                                          inManagedObjectContext:[self managedObjectContext]];
        
        //[newManagedObject ];
        [newManagedObject setValue:[[alarms objectAtIndex:i] alarmDateTime] forKey:@"alarmDateTime"];
        [newManagedObject setValue:[[alarms objectAtIndex:i] alarmSound] forKey:@"alarmSound"];
        [newManagedObject setValue:[[alarms objectAtIndex:i] alarmMessage] forKey:@"alarmMessage"];
        [newManagedObject setValue:[NSNumber numberWithFloat:[[alarms objectAtIndex:i] alarmVolume]] forKey:@"alarmVolume"];
        [newManagedObject setValue:[NSNumber numberWithInt:[[alarms objectAtIndex:i] snoozeDuration]] forKey:@"snoozeDuration"];
        [newManagedObject setValue:[NSNumber numberWithBool:[[alarms objectAtIndex:i] isSnoozeEnabled]] forKey:@"isSnoozeEnabled"];
        [newManagedObject setValue:[NSNumber numberWithBool:[[alarms objectAtIndex:i] isSetToVibrate]] forKey:@"isSetToVibrate"];
        [newManagedObject setValue:[NSNumber numberWithBool:[[alarms objectAtIndex:i] isSetToFlash]] forKey:@"isSetToFlash"];
        
         [self saveContext];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    
    if([player isPlaying])
        [player stop];

    if(!alarms) {
        NSLog(@"alarms == nil alloc new array");
        alarms = [[NSMutableArray alloc] init];
    }
    
    if(alarms)
    {
        //restart fetch alarms
        NSLog(@"alarms ! nil so fetching into from db");
        [self fetchAlarms];
    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AlarmClockiOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AlarmClockiOS.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
