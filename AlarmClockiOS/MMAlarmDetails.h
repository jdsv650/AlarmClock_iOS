//
//  MMAlarmDetails.h
//  AlarmClockiOS
//
//  Created by James Donner on 3/8/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MMAlarmDetails : NSObject

@property NSDate *alarmDateTime;
@property NSString *alarmSound;
@property NSString *alarmMessage;
@property float alarmVolume;
@property int snoozeDuration;
@property BOOL isSnoozeEnabled;
@property BOOL isSetToVibrate;
@property BOOL isSetToFlash;

@end
