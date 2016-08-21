//
//  CalendarYearModel.h
//  Calendar
//
//  Created by iLeo-OC on 16/8/19.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarMonthModel.h"
@interface CalendarYearModel : NSObject

@property (nonatomic, copy) NSString *year;

@property (nonatomic, assign, getter=isLeapYear) BOOL leapYear;

@property (nonatomic, strong) NSArray *calendarMonthArr;

@end
