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
    __weak IBOutlet UILabel *currentTimeOutlet;
    NSTimer *timerToUpdateCurrentTime;
    AVAudioPlayer *player;
    NSDate *alarm1Date;
    int nextAlarmNum;
    BOOL isAlarmActive;
}
- (IBAction)addAlarmPressed:(id)sender;


@end

@implementation MMAlarmMainViewController
@synthesize alarms;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isAlarmActive= NO;
   // alarm1Date = [NSDate dateWithTimeIntervalSinceNow:30];
    
    if(!alarms) {
        alarms = [[NSMutableArray alloc] init];
        nextAlarmNum = -1;
   // [alarms addObject:alarm1Date];
        
    }
     
    
    SEL sel = @selector(updateTime);
    
    timerToUpdateCurrentTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:sel userInfo:nil repeats:YES];
    
}


- (void)updateTime
{
    NSComparisonResult *result;
   // result = [[NSDate date] ];
    
    //-1 no alarms out of bounds
    nextAlarmNum = alarms.count-1;
    
    
    currentTimeOutlet.text = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    if(nextAlarmNum < 0 || isAlarmActive)
    {
        //do nothing
        NSLog(@"No alarm found or active alarm");
    }
    else
        if (([[NSDate date] compare:[alarms objectAtIndex:nextAlarmNum]] == NSOrderedDescending) ||
            ([[NSDate date] compare:[alarms objectAtIndex:nextAlarmNum]] == NSOrderedSame))
    {
        
//        UIStoryboard *storyboard = self.storyboard;
//         MMAlarmSoundedViewController* sounded = [storyboard instantiateViewControllerWithIdentifier:@"soundedViewController"];
//        [self presentViewController:sounded animated:NO completion:NULL];
        //[self performSegueWithIdentifier:@"alarmSoundedSegue" sender:self];
        
        isAlarmActive = YES;
        [self startAlarmSound];
        [self popUpForDismissAlarm];
    }
    else
    {
        NSLog(@"Not time yet");
    }
    
}


-(void) startAlarmSound
{
    //Sound alarm
    NSString *soundFilePath = [NSString stringWithFormat:@"%@/Tornado_siren.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
    player.numberOfLoops = -1; //Infinite
    [player play];
}


-(void) popUpForDismissAlarm
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alarm is Active"
                                                    message:@"Alarm OFF"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:@"Snooze",nil];
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
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        NSLog(@"OK button was selected.");
    }
    else if([title isEqualToString:@"Snooze"])
    {
        NSLog(@"Snooze button was selected.");
    }
    
    [player stop];
    isAlarmActive = NO;
    [alarms removeLastObject];
}

- (IBAction)addAlarmPressed:(id)sender
{ }

@end
