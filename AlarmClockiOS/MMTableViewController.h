//
//  MMTableViewController.h
//  AlarmClockiOS
//
//  Created by James Donner on 3/8/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAlarmDetails.h"  

@interface MMTableViewController : UITableViewController

@property NSMutableArray *alarms;
@property MMAlarmDetails *editAlarm;
@property NSInteger alarmNumberToEdit;

@end
