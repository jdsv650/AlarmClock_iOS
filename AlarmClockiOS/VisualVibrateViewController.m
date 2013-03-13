//
//  VisualVibrateViewController.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/11/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "VisualVibrateViewController.h"
#import "MMTableViewController.h"

@interface VisualVibrateViewController ()
{
    __weak IBOutlet UITextField *messageTextField;
    __weak IBOutlet UISwitch *vibrateSwitch;
    __weak IBOutlet UISwitch *flashlightSwitch;
    
    MMAlarmMainViewController *avc;
    MMTableViewController *tvc;
}
- (IBAction)throwVibrateSwitch:(id)sender;
- (IBAction)throwFlashlightSwitch:(id)sender;


@end

@implementation VisualVibrateViewController
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
    
    vibrateSwitch.on = myAlarm.isSetToVibrate;
    flashlightSwitch.on = myAlarm.isSetToFlash;
    messageTextField.text = myAlarm.alarmMessage;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    myAlarm.alarmMessage = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)throwVibrateSwitch:(id)sender {
    myAlarm.isSetToVibrate = vibrateSwitch.isOn;
}

- (IBAction)throwFlashlightSwitch:(id)sender {
    myAlarm.isSetToFlash = flashlightSwitch.isOn;
}
@end
