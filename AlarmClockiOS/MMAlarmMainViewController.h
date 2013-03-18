//
//  MMAlarmMainViewController.h
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAlarmDetails.h"
#import <CoreData/CoreData.h>

@interface MMAlarmMainViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSMutableArray *alarms;
@property MMAlarmDetails *myNewAlarm;
@property int alarmNumberToEdit;
@property BOOL isEdit;

@end
