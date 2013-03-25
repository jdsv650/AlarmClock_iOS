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
    __weak IBOutlet UIImageView *vibrateImageViewOutlet;
    __weak IBOutlet UIImageView *flashlightImageViewOutlet;
    
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
    
    //[vibrateImageViewOutlet setHidden:YES];
    //[vibrateSwitch setHidden:YES];
	
    if([self.presentingViewController isKindOfClass:[MMTableViewController class]])  //edit alarm
    {
        tvc = (MMTableViewController*) self.presentingViewController;
        myAlarm = tvc.editAlarm;
       
    }
    else   //new alarm
    {
        avc = (MMAlarmMainViewController*) self.presentingViewController;
        myAlarm = avc.myNewAlarm;
    }
    
    vibrateSwitch.on = myAlarm.isSetToVibrate;
    flashlightSwitch.on = myAlarm.isSetToFlash;
    messageTextField.text = myAlarm.alarmMessage;
    
    if(vibrateSwitch.on == YES)
    {
        vibrateImageViewOutlet.image = [UIImage imageNamed:@"ipod_cast.png"];
    }
    else
        vibrateImageViewOutlet.image = [UIImage imageNamed:@"ipod_cast_off.png"];
    
    if(flashlightSwitch.on == YES)
    {
        flashlightImageViewOutlet.image = [UIImage imageNamed:@"lightbulb.png"];
    }
    else
        flashlightImageViewOutlet.image = [UIImage imageNamed:@"lightbulb_off.png"];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    myAlarm.alarmMessage = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)throwVibrateSwitch:(id)sender
{
    
    myAlarm.isSetToVibrate = vibrateSwitch.isOn;
    if(vibrateSwitch.on == YES)
    {
        vibrateImageViewOutlet.image = [UIImage imageNamed:@"ipod_cast.png"];
    }
    else
        vibrateImageViewOutlet.image = [UIImage imageNamed:@"ipod_cast_off.png"];
}

- (IBAction)throwFlashlightSwitch:(id)sender
{
    myAlarm.isSetToFlash = flashlightSwitch.isOn;
    if(flashlightSwitch.on == YES)
    {
        flashlightImageViewOutlet.image = [UIImage imageNamed:@"lightbulb.png"];
    }
    else
        flashlightImageViewOutlet.image = [UIImage imageNamed:@"lightbulb_off.png"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
