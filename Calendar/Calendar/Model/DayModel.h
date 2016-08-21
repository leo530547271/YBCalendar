//
//  DayModel.h
//  Calendar
//
//  Created by iLeo-OC on 16/8/17.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemindMe.h"
@interface DayModel : NSObject
//周几
@property (nonatomic, copy) NSString *weekday;
//几号
@property (nonatomic, copy) NSString *dayInMonth;
//提醒内容
@property (nonatomic, strong) RemindMe *remindMe;

//是否为选择天
@property (nonatomic, assign, getter=isSelectedDay) BOOL selectedDay;
//节日
@property (nonatomic, strong) NSString *festival;

//是否休息
@property (nonatomic, assign, getter=isRestDay) BOOL restDay;
//是否上班
@property (nonatomic, assign, getter=isWorkDay) BOOL workDay;



@end
