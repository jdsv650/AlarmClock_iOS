//
//  MMSecondViewController.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "AudibleViewController.h"
#import "MMAlarmMainViewController.h"
#import "MMTableViewController.h"
#import "MMTableViewController.h"

@interface AudibleViewController ()
{
    __weak IBOutlet UIImageView *audibleImageViewOutlet;
    __weak IBOutlet UISlider *volumeOutlet;
    __weak IBOutlet UIPickerView *soundPickerOutlet;
    __weak IBOutlet UISwitch *volumeOnOffOutlet;
    __weak IBOutlet UILabel *volumeLabelOutlet;
    __weak IBOutlet UIImageView *volumeImageViewOutlet;
    __weak IBOutlet UISlider *sliderOutlet;
    MMAlarmMainViewController *avc;
    MMTableViewController *tvc;
    
}
- (IBAction)toggleVolumeOnOff:(id)sender;
- (IBAction)volumeChanged:(id)sender;

@end

@implementation AudibleViewController
@synthesize sounds;
@synthesize myNewAlarm;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    volumeLabelOutlet.hidden = YES;
    volumeImageViewOutlet.hidden = YES;
    sliderOutlet.hidden = YES;
    
    if([self.presentingViewController isKindOfClass:[MMTableViewController class]])
    {
        tvc = (MMTableViewController*) self.presentingViewController;
        myNewAlarm = tvc.editAlarm;
    }
    else
    {
        avc = (MMAlarmMainViewController*) self.presentingViewController;
        myNewAlarm = avc.myNewAlarm;
    }
    
    sounds = [[NSArray alloc] initWithObjects:@"Alarm Clock", @"Car Alarm", @"Evacuate", @"Rooster", @"Tornado Siren", nil];
    
    volumeOutlet.value = myNewAlarm.alarmVolume;
    if(myNewAlarm.alarmVolume == 0)
    {
       volumeOnOffOutlet.on = NO;
       audibleImageViewOutlet.image = [UIImage imageNamed:@"bell_off.png"];
    }
    else
         audibleImageViewOutlet.image = [UIImage imageNamed:@"bell.png"];

    int num = 0;
    if([[myNewAlarm alarmSound] isEqualToString:@"Alarm Clock"])
    {
        num = 0;
    }
    else
        if([[myNewAlarm alarmSound] isEqualToString:@"Car Alarm"])
    {
        num = 1;
    }
    else
        if([[myNewAlarm alarmSound] isEqualToString:@"Evacuate"])
    {
        num = 2;
    }
    else
        if([[myNewAlarm alarmSound] isEqualToString:@"Rooster"])
    {
        num = 3;
    }
    else
        if([[myNewAlarm alarmSound] isEqualToString:@"Tornado Siren"])
    {
        num = 4;
    }

    [soundPickerOutlet selectRow:num inComponent:0 animated:YES];
}

//datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//datasource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return sounds.count;
}


//delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [sounds objectAtIndex:row];
}

//delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    myNewAlarm.alarmSound = [sounds objectAtIndex:row];
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}


- (IBAction)toggleVolumeOnOff:(id)sender
{
    if ([sender isOn])
    {
        volumeOutlet.value = 0.5f;
        myNewAlarm.alarmVolume = 0.5f;
        audibleImageViewOutlet.image = [UIImage imageNamed:@"bell.png"];
    }
    else
    {
        volumeOutlet.value = 0.0f;
        myNewAlarm.alarmVolume = 0.0f;
        audibleImageViewOutlet.image = [UIImage imageNamed:@"bell_off.png"];
    }
}

- (IBAction)volumeChanged:(id)sender {
    if (volumeOutlet.value == 0)
    {
        volumeOnOffOutlet.on = NO;
        myNewAlarm.alarmVolume = 0.0f;
        audibleImageViewOutlet.image = [UIImage imageNamed:@"bell_off.png"];
    }
    else
    {
        volumeOnOffOutlet.on = YES;
        myNewAlarm.alarmVolume = volumeOutlet.value;
        audibleImageViewOutlet.image = [UIImage imageNamed:@"bell.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    volumeLabelOutlet = nil;
    volumeImageViewOutlet = nil;
    sliderOutlet = nil;
    [super viewDidUnload];
}
@end
