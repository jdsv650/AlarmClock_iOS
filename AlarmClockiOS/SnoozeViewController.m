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
    __weak IBOutlet UIPickerView *snoozeIntervalPicker;
    __weak IBOutlet UISwitch *snoozeSwitch;
    MMAlarmMainViewController *avc;
    MMTableViewController *tvc;
    NSArray *snoozeIntervals;
    NSArray *snoozeIntervalsAsInt;
}

- (IBAction)turnSnoozeOnOff:(id)sender;

@end

@implementation SnoozeViewController
@synthesize myAlarm;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    snoozeIntervals = [[NSArray alloc] initWithObjects:@"Snooze Off", @" 5 Minutes", @"10 Minutes", @"15 Minutes", @"20 Minutes", @"25 Minutes", @"30 Minutes", nil];
    snoozeIntervalsAsInt = [[NSArray alloc] initWithObjects:@"0", @"5", @"10", @"15", @"20", @"25", @"30", nil];
   
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
        [snoozeIntervalPicker selectRow:(myAlarm.snoozeDuration / 5) inComponent:0 animated:YES];
    }
    else
    {
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break_off.png"];
        [snoozeIntervalPicker selectRow:0 inComponent:0 animated:YES];
    }
    
}

//datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//datasource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return snoozeIntervals.count;
}

//delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [snoozeIntervals objectAtIndex:row];
}

//delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    myAlarm.snoozeDuration = [[snoozeIntervalsAsInt objectAtIndex:row] integerValue];
    if(row == 0)
    {
        snoozeSwitch.on = NO;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break_off.png"];
        myAlarm.isSnoozeEnabled = NO;
    }
    else
    {
        snoozeSwitch.on = YES;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break.png"];
        myAlarm.isSnoozeEnabled = YES;
    }
}

- (IBAction)turnSnoozeOnOff:(id)sender {
    if(snoozeSwitch.on == NO) {
        myAlarm.isSnoozeEnabled = NO;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break_off.png"];
        [snoozeIntervalPicker selectRow:0 inComponent:0 animated:YES];
    }
    else
    {
        myAlarm.isSnoozeEnabled = YES;
        snoozeImageViewOutlet.image = [UIImage imageNamed:@"link_break.png"];
        [snoozeIntervalPicker selectRow:2 inComponent:0 animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    snoozeIntervalPicker = nil;
    [super viewDidUnload];
}
@end
