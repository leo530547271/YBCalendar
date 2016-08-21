//
//  CalendarMonthModel.h
//  Calendar
//
//  Created by iLeo-OC on 16/8/16.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DayModel.h"

@interface CalendarMonthModel : NSObject



@property (nonatomic, copy) NSString *month;
//这个月的第一天是星期几
//@property (nonatomic, assign) enum YBWeek firstDayOfMonth;
//这个月所有天
@property (nonatomic, strong) NSArray *daysInMonth;



@end
