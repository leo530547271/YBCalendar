//
//  DayView.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/17.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "DayView.h"

@interface DayView()

@property (weak, nonatomic) IBOutlet UILabel *mydate;

@property (weak, nonatomic) IBOutlet UILabel *chineseDate;

@property (weak, nonatomic) IBOutlet UILabel *workOrRest;

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UIView *selectedView;

@property (weak, nonatomic) IBOutlet UIView *choseDay;

@end

@implementation DayView


- (void)awakeFromNib
{
//    self.layer.cornerRadius = 2;
    self.img.layer.cornerRadius = self.img.bounds.size.height*0.5;
    self.img.clipsToBounds = YES;
    self.img.hidden = YES;
    self.selectedView.hidden = YES;
    self.choseDay.hidden = YES;
}
- (void)setShowBackgrand:(BOOL)showBackgrand
{
    _showBackgrand = showBackgrand;
    if (showBackgrand) {
        if (self.choseDay.hidden) {
            [UIView animateWithDuration:0.1 animations:^{
                self.selectedView.hidden = NO;
            }];
        }
        
        
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedView.hidden = YES;
        }];
        
    }
}
- (void)setDay:(DayModel *)day
{
    
    _day = day;
    _mydate.text = day.dayInMonth;
    if (day.festival) {
        _chineseDate.text = day.festival;
    }else{
        _chineseDate.text = @"初几";
    }
    
    if (day.remindMe != nil) {
        self.img.hidden = NO;
    }else{
        self.img.hidden = YES;
    }
    if (day.isSelectedDay) {
        self.choseDay.hidden = NO;
        self.selectedView.hidden = YES;
    }else{
        self.choseDay.hidden = YES;
    }
    if (day.isWorkDay) {
        self.workOrRest.hidden = NO;
        self.workOrRest.textColor = [UIColor orangeColor];
        self.workOrRest.text = @"班";
    }else{
        if (day.isRestDay) {
            self.workOrRest.textColor = [UIColor colorWithRed:0.116 green:0.685 blue:0.324 alpha:1.000];
            self.workOrRest.text = @"休";
        }else{
            self.workOrRest.hidden = YES;
        }
    }
    
}

@end
