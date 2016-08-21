//
//  CalendarModel.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/16.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "CalendarMonthModel.h"
#import <MJExtension.h>
@implementation CalendarMonthModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"daysInMonth" : [DayModel class]};
}

@end
