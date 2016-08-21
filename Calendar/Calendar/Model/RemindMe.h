//
//  RemindMe.h
//  Calendar
//
//  Created by iLeo-OC on 16/8/17.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindMe : NSObject
//提醒名称
@property (nonatomic, copy) NSString *name;
//提醒内容
@property (nonatomic, copy) NSString *content;
//提醒时段--开始
@property (nonatomic, copy) NSString *startTime;
//提醒时段--结束
@property (nonatomic, copy) NSString *endTime;
//提醒频率
@property (nonatomic, copy) NSString *frequencyForFiveMins;
@end
