//
//  MMAlarmMainViewController.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "AlarmTimeViewController.h"
#import "MMAlarmMainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MMAlarmMainViewController ()
{
    __weak IBOutlet UIButton *nextAlarmOutlet;
    __weak IBOutlet UILabel *currentTimeOutlet;
    NSTimer *timerToUpdateCurrentTime;
    AVAudioPlayer *player;
    int nextAlarmNum;
    BOOL isAlarmActive;
    NSCalendar *gregorian;
    NSDateFormatter *formatter;
}
- (IBAction)addAlarmPressed:(id)sender;
- (IBAction)nextAlarmPressed:(id)sender;


@end

@implementation MMAlarmMainViewController
@synthesize alarms;
@synthesize myNewAlarm;
@synthesize alarmNumberToEdit;
@synthesize isEdit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];
    //@"MM/dd/yyyy HH:mm:ss a"
    
    isAlarmActive= NO;
    isEdit = NO;
    
    if(!alarms) {
        alarms = [[NSMutableArray alloc] init];
        nextAlarmNum = -1;
        nextAlarmOutlet.enabled = NO;
        alarmNumberToEdit = -1;
    }
 
    SEL sel = @selector(updateTime);
    
    gregorian = [[NSCalendar alloc]
                initWithCalendarIdentifier:NSGregorianCalendar];
    
    timerToUpdateCurrentTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:sel userInfo:nil repeats:YES];

}


- (void)updateTime
{
    //-1 no alarms out of bounds
    nextAlarmNum = alarms.count-1;
    isEdit = NO;
    
    if(alarms.count <= 0) {
        [nextAlarmOutlet setTitle:@"No Alarms" forState:UIControlStateNormal];
        alarmNumberToEdit = -1;
        nextAlarmOutlet.enabled = NO;
    }
    else
    {
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a V"];
        
        [nextAlarmOutlet setTitle:[formatter stringFromDate:[[alarms lastObject] alarmDateTime]]
                         forState:UIControlStateNormal];
        alarmNumberToEdit = alarms.count-1;
        nextAlarmOutlet.enabled = YES;
    }
    
    NSDate *now = [[NSDate alloc] init];
    
    currentTimeOutlet.text = [formatter stringFromDate:now];
    
    if(nextAlarmNum < 0 || isAlarmActive)
    {
        //do nothing
     //   NSLog(@"No alarm found or active alarm");
    }
    else
        if (([[NSDate date] compare:[[alarms objectAtIndex:nextAlarmNum] alarmDateTime]] == NSOrderedDescending) ||
           ([[NSDate date] compare:[[alarms objectAtIndex:nextAlarmNum] alarmDateTime]] == NSOrderedSame))
    {
        isAlarmActive = YES;
        [self startAlarmSound];
        
        if([[alarms objectAtIndex:nextAlarmNum] isSetToVibrate])
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        [self popUpForDismissAlarm];
    }
    else
    {
       // NSLog(@"Not time yet");
    }
    
}


-(void) startAlarmSound
{
    //Sound alarm
    NSString *soundFilePath;
    
    if([[[alarms objectAtIndex:nextAlarmNum] alarmSound] isEqualToString:@"Alarm Clock"])
    {
        soundFilePath = [NSString stringWithFormat:@"%@/Alarm_Clock.mp3", [[NSBundle mainBundle] resourcePath]];
    }
    else if([[[alarms objectAtIndex:nextAlarmNum] alarmSound] isEqualToString:@"Car Alarm"])
    {
         soundFilePath = [NSString stringWithFormat:@"%@/Car_Alarm.mp3", [[NSBundle mainBundle] resourcePath]];
    }
    else if([[[alarms objectAtIndex:nextAlarmNum] alarmSound] isEqualToString:@"Evacuate"])
    {
        soundFilePath = [NSString stringWithFormat:@"%@/Evacuate.mp3", [[NSBundle mainBundle] resourcePath]];
    }
    else if([[[alarms objectAtIndex:nextAlarmNum] alarmSound] isEqualToString:@"Rooster"])
    {
        soundFilePath = [NSString stringWithFormat:@"%@/Rooster.mp3", [[NSBundle mainBundle] resourcePath]];
    }
    else
        soundFilePath = [NSString stringWithFormat:@"%@/Tornado_Siren.mp3", [[NSBundle mainBundle] resourcePath]];
    
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.volume = [[alarms objectAtIndex:nextAlarmNum] alarmVolume];
    player.numberOfLoops = -1; //keep playing
    [player play];
}


-(void) popUpForDismissAlarm
{
    UIAlertView *alert;
    
    if([[alarms objectAtIndex:nextAlarmNum] isSnoozeEnabled])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Alarm is Active"
                                                    message:[[alarms objectAtIndex:nextAlarmNum] alarmMessage]
                                                   delegate:self
                                          cancelButtonTitle:@"OFF"
                                          otherButtonTitles:@"Snooze",nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Alarm is Active"
                                           message:[[alarms objectAtIndex:nextAlarmNum] alarmMessage]
                                          delegate:self
                                 cancelButtonTitle:@"OFF"
                                 otherButtonTitles:nil];
    }
    
    [alert show];
}


//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    AlarmTimeViewController *atvc = [segue destinationViewController];
//    atvc.alarms = alarms;
//    
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [player stop];
    isAlarmActive = NO;
 
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OFF"])
    {
        NSLog(@"OFF button was selected.");
        [alarms removeLastObject];
    }
    else if([title isEqualToString:@"Snooze"])
    {
        NSLog(@"Snooze button was selected.");
        MMAlarmDetails *snoozeAlarm = [alarms lastObject];
        [snoozeAlarm setAlarmDateTime:[[snoozeAlarm alarmDateTime] dateByAddingTimeInterval:[snoozeAlarm snoozeDuration] * 60]];
        [alarms removeLastObject];
        [self addSnoozeAlarm:snoozeAlarm];
    }

}

-(void) addSnoozeAlarm:(MMAlarmDetails *)alarm
{
    int idx;
    NSComparisonResult result;
    NSDate *dateFromAlarm = [alarm alarmDateTime];
   
    for(idx=0; idx<alarms.count; idx++) {
        result = [[[alarms objectAtIndex:idx] alarmDateTime] compare:dateFromAlarm];
        
        if(result==NSOrderedAscending)
        {
            //   NSLog(@"Date1 is in the future");
            break;
        }
    }
    
    [alarms insertObject:alarm atIndex:idx];
}

- (IBAction)addAlarmPressed:(id)sender
{
    myNewAlarm = [[MMAlarmDetails alloc] init];
    myNewAlarm.alarmDateTime = [[NSDate alloc] init];
    myNewAlarm.alarmSound = @"Alarm Clock";
    myNewAlarm.alarmVolume = 0.5f;
    myNewAlarm.isSnoozeEnabled = YES;
    myNewAlarm.snoozeDuration = 10;
    myNewAlarm.alarmMessage =  @"";
    myNewAlarm.isSetToFlash = NO;
    myNewAlarm.isSetToVibrate = NO;
}

- (IBAction)nextAlarmPressed:(id)sender
{
    isEdit = YES;
}

@end
