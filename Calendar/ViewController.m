//
//  ViewController.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/16.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "ViewController.h"
#import "CalendarYearModel.h"
#import "CalendarView.h"
#import "DayView.h"
#import "DaysView.h"
#import <MJExtension.h>

#import "SettingRemindMe.h"

#import "RemindView.h"


@interface ViewController ()<CalendarViewDelegate>
//@property (nonatomic, strong) NSArray *calendarArr;
@property (nonatomic, strong) CalendarYearModel *calendarYearModel;
@property (nonatomic, weak) CalendarView *calendarView;
@property (nonatomic, assign) int monthIndex;

@property (nonatomic, strong) RemindView *myLabel;

@property (nonatomic, assign) BOOL longPressState;

@property (nonatomic, assign) CGRect currentFrame;

@end

@implementation ViewController

- (CalendarYearModel *)calendarYearModel
{
    if (_calendarYearModel == nil) {
        _calendarYearModel = [CalendarYearModel mj_objectWithFilename:@"CalendarYearPlist.plist"];
    }
    return _calendarYearModel;
}

//- (CalendarModel *)calendarModel
//{
//    if (_calendarModel == nil) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"CalendarPlist.plist" ofType:nil];
//        
//        _calendarModel = [CalendarModel mj_objectWithFile:path];
//    }
//    return _calendarModel;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //创建一个日历
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarHeight:) name:YBCalendarShouldChangeHeight object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longPressDay:) name:YBDayViewDidLongPressed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarDidTapDay:) name:YBDayViewDidTap object:nil];
    CalendarView *myCalendar = [[[NSBundle mainBundle] loadNibNamed:@"CalendarView" owner:nil options:nil] lastObject];
    myCalendar.delegate = self;
    self.calendarView = myCalendar;
    myCalendar.calendarYearModel = self.calendarYearModel;
    myCalendar.frame = CGRectMake(0, 20, self.view.bounds.size.width, 400);
    [self.view addSubview:myCalendar];
    //创建日历下面详细信息
    RemindView *myLabel = [[[NSBundle mainBundle] loadNibNamed:@"RemindView" owner:nil options:nil] lastObject];
    self.myLabel = myLabel;
    myLabel.frame = CGRectMake(0, 0, myCalendar.bounds.size.width, 0);
    [self.view addSubview:myLabel];
    
}

- (void) calendarDidTapDay:(NSNotification *) notification
{
    DayView *dayView = [notification.userInfo objectForKey:YBDayViewTapDay];
    DayModel *dayModel = dayView.day;
    self.myLabel.dayModel = dayModel;
    
}

- (void) changeCalendarHeight:(NSNotification *) notification
{
    NSNumber *heightNum = [notification.userInfo objectForKey:YBCalendarRealHeight];
    CGFloat height = heightNum.floatValue;
    CGRect frame = self.calendarView.frame;
    frame.size.height = heightNum.floatValue;
    self.calendarView.frame = frame;
    self.myLabel.frame = CGRectMake(0, CGRectGetMaxY(self.calendarView.frame), self.calendarView.bounds.size.width, 90);
    
}
//长按某天
- (void) longPressDay:(NSNotification *) notification
{
    if (self.longPressState!=YES) {
        DayView *dayView = [notification.userInfo objectForKey:YBDayViewLongPressDay];
        NSString *month = [notification.userInfo objectForKey:YBDayViewLongPressedDayMonth];
        [self insertViewWithDay:dayView Month:month];
        self.longPressState = YES;

    }
}


- (void) insertViewWithDay:(DayView *)day Month:(NSString *)month
{
    //添加背景蒙版
    UIView *blackView = [[UIView alloc] init];
    blackView.frame = self.view.bounds;
    blackView.alpha = 1;
    blackView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewDidTap:)];
    [blackView addGestureRecognizer:tap];
    [self.view addSubview:blackView];
    CGRect currentFrame = [self.view convertRect:day.frame fromView:day.superview];
    self.currentFrame = currentFrame;
    SettingRemindMe *settingView = [[[NSBundle mainBundle] loadNibNamed:@"SettingRemindMe" owner:nil options:nil] firstObject];
    [settingView setSettingViewWithDayModel:day.day Month:month];
    settingView.clipsToBounds = YES;
    settingView.layer.cornerRadius = 10;
    settingView.tag = 100;
    settingView.alpha = 0;
    settingView.frame = currentFrame;
    [self.view addSubview:settingView];
    [UIView animateWithDuration:0.3 animations:^{
        blackView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.601];
        settingView.frame = CGRectMake(0, 0, 200, 150);
        settingView.center = self.view.center;
        settingView.alpha = 1;
    }];
}

- (void)blackViewDidTap:(UIGestureRecognizer *)gesture
{
    UIView *blackView = gesture.view;
    SettingRemindMe *settingView = [self.view viewWithTag:100];
    [settingView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [UIView animateWithDuration:0.2 animations:^{
        settingView.frame = self.currentFrame;
        settingView.alpha = 0;
        blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
        [settingView removeFromSuperview];
        self.longPressState = NO;
    }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
