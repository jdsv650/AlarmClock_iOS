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
    
    __weak IBOutlet UIImageView *snoozeImageViewOutlet;
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
    if(snoozeSwitch.on == YES)
    {
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break.png"];
    }
    else
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break_off.png"];
    
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
    if(stepper.value == 0)
    {
        snoozeSwitch.on = NO;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break_off.png"];
    }
    else
    {
        snoozeSwitch.on = YES;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break.png"];
    }
}

- (IBAction)turnSnoozeOnOff:(id)sender {
    if(snoozeSwitch.on == NO) {
        // snoozeStepper.enabled = NO;
        myAlarm.isSnoozeEnabled = NO;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break_off.png"];
        snoozeStepper.value = 0;
        snoozeLabel.text = @"0";
    }
    else
    {
        // snoozeStepper.enabled = YES;
        myAlarm.isSnoozeEnabled = YES;
        snoozeStepper.value = 10;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break.png"];
        snoozeLabel.text = [NSString stringWithFormat:@"%d", (int) snoozeStepper.value];
    }
}
@end
