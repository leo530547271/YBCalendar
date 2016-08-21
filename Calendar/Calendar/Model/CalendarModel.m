//
//  CalendarModel.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/19.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "CalendarModel.h"
#import <MJExtension.h>
@implementation CalendarModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"calendarYearArr" : [CalendarYearModel class]};
}

@end
