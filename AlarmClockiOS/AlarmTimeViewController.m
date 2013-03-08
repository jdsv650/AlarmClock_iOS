//
//  MMFirstViewController.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "AlarmTimeViewController.h"
#import "MMAlarmMainViewController.h"

@interface AlarmTimeViewController ()
{
    __weak IBOutlet UIDatePicker *alarmDatePickerOutlet;
    __weak IBOutlet UIButton *alarmOnOffToggleOutlet;
    MMAlarmMainViewController *avc;
    
    
}
- (IBAction)saveAlarm:(id)sender;


@end

@implementation AlarmTimeViewController
@synthesize alarms;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   avc = (MMAlarmMainViewController*) self.presentingViewController;
   alarms = avc.alarms;
	
    NSLog(@"Alarms = %@", alarms);
}


- (IBAction)saveAlarm:(id)sender {
    int idx;
    NSComparisonResult result;
    
    for(idx=0; idx<alarms.count; idx++) {
        result = [[alarms objectAtIndex:idx] compare:[alarmDatePickerOutlet date]];
        
        if(result==NSOrderedAscending)
        {
            NSLog(@"Date1 is in the future");
            break;
        }
        else if(result==NSOrderedDescending)
            NSLog(@"Date1 is in the past");
        else
            NSLog(@"dates are the same");
        
    }
    
    [alarms insertObject:[alarmDatePickerOutlet date] atIndex:idx];
    //[alarms addObject:[alarmDatePickerOutlet date]];
    avc.alarms = alarms;
    [self dismissViewControllerAnimated:YES completion:^ void {}];
}
@end
