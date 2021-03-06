//
//  MMSecondViewController.h
//  AlarmClockiOS
//
//  Created by James Donner on 3/7/13.
//  Copyright (c) 2013 jdsv650. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAlarmDetails.h"

@interface AudibleViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITabBarDelegate>

@property (strong, nonatomic) NSArray* sounds;
@property MMAlarmDetails *myNewAlarm;

@end
