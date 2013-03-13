//
//  MMAlarmDetails.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/8/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "MMAlarmDetails.h"

@implementation MMAlarmDetails

@synthesize alarmDateTime;  //date
@synthesize alarmSound;     //string
@synthesize alarmMessage; //string
@synthesize alarmVolume;    //float
@synthesize snoozeDuration;  //int


@synthesize isSnoozeEnabled;
@synthesize isSetToVibrate; //bool
@synthesize isSetToFlash;   //bool

@end
