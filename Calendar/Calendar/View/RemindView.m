//
//  RemindView.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/20.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "RemindView.h"

@interface RemindView()

@property (weak, nonatomic) IBOutlet UILabel *actionName;

@property (weak, nonatomic) IBOutlet UILabel *actionTime;

@property (weak, nonatomic) IBOutlet UILabel *briefContent;

@end


@implementation RemindView

- (void)setDayModel:(DayModel *)dayModel
{
    _dayModel = dayModel;
    if (dayModel.remindMe != nil) {
        _actionName.text = dayModel.remindMe.name;
        _actionTime.text = @"全天";
        _briefContent.text = dayModel.remindMe.content;
    }else{
        _actionName.text = @"无日程";
        _actionTime.text = @"";
        _briefContent.text = @"";
    }
    
}

@end
