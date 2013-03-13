//
//  SnoozeViewController.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "SnoozeViewController.h"
#import "MMAlarmMainViewController.h"
#import "MMTableViewController.h"

@interface SnoozeViewController ()
{
    
    __weak IBOutlet UISwitch *snoozeSwitch;
    __weak IBOutlet UILabel *snoozeLabel;
    __weak IBOutlet UIStepper *snoozeStepper;
     MMAlarmMainViewController *avc;
    MMTableViewController *tvc;
}
- (IBAction)snoozeStepper:(id)sender;
- (IBAction)turnSnoozeOnOff:(id)sender;


@end

@implementation SnoozeViewController
@synthesize myAlarm;


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if([self.presentingViewController isKindOfClass:[MMTableViewController class]])
    {
        tvc = (MMTableViewController*) self.presentingViewController;
        myAlarm = tvc.editAlarm;
    }
    else
    {
    avc = (MMAlarmMainViewController*) self.presentingViewController;
    myAlarm = avc.myNewAlarm;
    }
    
    snoozeSwitch.on = myAlarm.isSnoozeEnabled;
    snoozeLabel.text = [NSString stringWithFormat:@"%d", myAlarm.snoozeDuration];
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)snoozeStepper:(id)sender {
    UIStepper *stepper = (UIStepper *) sender;
    
    myAlarm.snoozeDuration = stepper.value;
    snoozeLabel.text = [NSString stringWithFormat:@"%d", (int) stepper.value];
    
}

- (IBAction)turnSnoozeOnOff:(id)sender {
    if(snoozeSwitch.on == NO) {
        snoozeStepper.enabled = NO;
        myAlarm.isSnoozeEnabled = NO;
        snoozeLabel.text = @"Snooze Off";
    }
    else
    {
        snoozeStepper.enabled = YES;
        myAlarm.isSnoozeEnabled = YES;
        snoozeLabel.text = [NSString stringWithFormat:@"%d", (int) snoozeStepper.value];
    }
    
}
@end
