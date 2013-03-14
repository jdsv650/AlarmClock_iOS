//
//  MMFirstViewController.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "AlarmTimeViewController.h"
#import "MMAlarmMainViewController.h"
#import "MMAlarmDetails.h"
#import "MMTableViewController.h"

@interface AlarmTimeViewController ()
{
    __weak IBOutlet UIDatePicker *alarmDatePickerOutlet;
    __weak IBOutlet UIButton *alarmOnOffToggleOutlet;
    __weak IBOutlet UIButton *removeButtonOutlet;
    MMAlarmMainViewController *avc;
    MMTableViewController *tvc;
    BOOL isNewAlarm;
    NSInteger alarmNumberToEdit;
}

- (IBAction)saveAlarm:(id)sender;
- (IBAction)alarmTimeChanged:(id)sender;
- (IBAction)RemoveAlarm:(id)sender;
- (IBAction)returnToMainPage:(id)sender;

@end

@implementation AlarmTimeViewController
@synthesize alarms;
@synthesize myAlarm;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Edit Alarm coming from table view controller
    if([self.presentingViewController isKindOfClass:[MMTableViewController class]])
    {
        tvc = (MMTableViewController*) self.presentingViewController;
        alarms = tvc.alarms;
        myAlarm = tvc.editAlarm;
        alarmNumberToEdit = tvc.alarmNumberToEdit;
        isNewAlarm = NO;
        removeButtonOutlet.hidden = NO;
    
    }
    else //ADD alarm coming from MMAlarmMainViewController
    {
        avc = (MMAlarmMainViewController*) self.presentingViewController;
        alarms = avc.alarms;
        myAlarm = avc.myNewAlarm;
        isNewAlarm = YES;
        removeButtonOutlet.hidden = YES;
    }
     NSLog(@"Alarms = %@", alarms);
        
    [alarmDatePickerOutlet setDatePickerMode:UIDatePickerModeTime];
    alarmDatePickerOutlet.date = myAlarm.alarmDateTime;
	
}


- (IBAction)saveAlarm:(id)sender {
    int idx;
    NSComparisonResult result;
    
    NSDate *dateFromPicker = [alarmDatePickerOutlet date];
    NSDate *now = [[NSDate alloc] init];
    
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
//    NSDateComponents *dateFromPickerComponents = [gregorian components:(NSSecondCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:dateFromPicker];
    
//    NSInteger pickerHour = [dateFromPickerComponents hour];
//    NSInteger pickerMin =  [dateFromPickerComponents minute];
//    NSInteger pickerSec =  [dateFromPickerComponents second];
//    
//    NSDateComponents *nowComponents = [gregorian components:(NSSecondCalendarUnit  | NSMinuteCalendarUnit | NSHourCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:now];
//    
//    NSInteger nowHour = [dateFromPickerComponents hour];
//    NSInteger nowMin =  [dateFromPickerComponents minute];
//    NSInteger nowSec =  [dateFromPickerComponents second];
    
    if(!isNewAlarm)
    {
         [alarms removeObjectAtIndex:alarmNumberToEdit];
    }
    
    
    if([dateFromPicker compare:now] == NSOrderedAscending)  //dateFromPicker already past alarm for tomorrow
    {
        NSLog(@"SUCK IT!!!");
        dateFromPicker = [dateFromPicker dateByAddingTimeInterval:(60*60*24)];
    }
    
    
    for(idx=0; idx<alarms.count; idx++) {
        result = [[[alarms objectAtIndex:idx] alarmDateTime] compare:dateFromPicker];
        
        if(result==NSOrderedAscending)
        {
         //   NSLog(@"Date1 is in the future");
            break;
        }
        
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    
    myAlarm.alarmDateTime = dateFromPicker;
    
    NSLog(@"sound = %@  datetime = %@   volume = %f   snooze interval = %d", myAlarm.alarmSound, [formatter stringFromDate:myAlarm.alarmDateTime], myAlarm.alarmVolume, myAlarm.snoozeDuration);
    
    if(isNewAlarm)
    {
        [alarms insertObject:myAlarm atIndex:idx];
    }
    
    if(!isNewAlarm)  //update table view on edit
    {
        //[alarms replaceObjectAtIndex:alarmNumberToEdit withObject:myAlarm];
        //potential time change so remove and insert in correct place instead of replace
        
        [alarms insertObject:myAlarm atIndex:idx];
        [[tvc tableView] reloadData];
    }
    avc.alarms = alarms;
    [self dismissViewControllerAnimated:YES completion:^ void {}];
}

//action for datepicker changed
- (IBAction)alarmTimeChanged:(id)sender {
}


- (IBAction)RemoveAlarm:(id)sender
{
    [alarms removeObjectAtIndex:alarmNumberToEdit];
    [[tvc tableView] reloadData];
    [self returnToMainPage:sender];
}

- (IBAction)returnToMainPage:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:^ void {}];
}
@end
