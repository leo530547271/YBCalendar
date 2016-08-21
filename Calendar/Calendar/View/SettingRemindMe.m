//
//  SettingRemindMe.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/21.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "SettingRemindMe.h"

@interface SettingRemindMe()


@property (weak, nonatomic) IBOutlet UILabel *monthAndDay;

@end


@implementation SettingRemindMe

- (void)awakeFromNib
{
    self.clipsToBounds = YES;
}

- (void)setSettingViewWithDayModel:(DayModel *)dayModel Month:(NSString *)month
{
    self.monthAndDay.text = [NSString stringWithFormat:@"%@月%@日  全天",month, dayModel.dayInMonth];
}

@end
