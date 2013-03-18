//
//  MMTableViewController.m
//  AlarmClockiOS
//
//  Created by James Donner on 3/8/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import "MMTableViewController.h"
#import "MMAlarmMainViewController.h"
#import "MMAlarmDetails.h"

@interface MMTableViewController ()
{
    MMAlarmMainViewController *avc;
    NSDateFormatter *formatter;
}
- (IBAction)returnToMainPage:(id)sender;

@end

@implementation MMTableViewController
@synthesize alarms;
@synthesize editAlarm;
@synthesize alarmNumberToEdit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    formatter = [[NSDateFormatter alloc] init];
    avc = (MMAlarmMainViewController*) self.presentingViewController;
    alarms = avc.alarms;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    alarmNumberToEdit = [[[self tableView] indexPathForSelectedRow] row];
    editAlarm = [alarms objectAtIndex:alarmNumberToEdit];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return alarms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CustomID";
   
   // iOS 6 
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //iOS 5
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomID"];
    }
    
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a V"];

    cell.textLabel.text = [formatter stringFromDate:[[alarms objectAtIndex:indexPath.row] alarmDateTime]];
 
   // cell.textLabel.text = [NSString stringWithFormat:@"%@", [[alarms objectAtIndex:indexPath.row] alarmDateTime]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (IBAction)returnToMainPage:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
