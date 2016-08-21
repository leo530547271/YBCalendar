//
//  CalendarYearModel.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/19.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "CalendarYearModel.h"
#import <MJExtension.h>
@implementation CalendarYearModel


- (void)setYear:(NSString *)year
{
    _year = [year copy];
    if (!(year.intValue%4 && year.intValue%400)) {
        self.leapYear = YES;
    }else{
        self.leapYear = NO;
    }
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"calendarMonthArr" : [CalendarMonthModel class]};
}

@end
