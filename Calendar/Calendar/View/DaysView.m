//
//  DaysView.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/18.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "DaysView.h"
#import "DayView.h"
#import "CalendarModel.h"
#define Ymargin 5
#define dayHeight 50

@interface DaysView()

@property (nonatomic, strong) NSArray *daysArr;

@property (nonatomic, strong) DayView *lastDayView;

//第一天星期几
@property (nonatomic, assign) NSInteger indexNum;



@end

@implementation DaysView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setDayViewCalendarMonthModel:(CalendarMonthModel *)dayViewCalendarMonthModel
{
    
    _dayViewCalendarMonthModel = dayViewCalendarMonthModel;
    if (dayViewCalendarMonthModel != nil) {
        NSArray *days = dayViewCalendarMonthModel.daysInMonth;
        
        for (int i = 0; i < self.daysArr.count; i++) {
            DayView *dayView = _daysArr[i];
            
            if (i < days.count) {
                DayModel *dayModel = days[i];
                dayView.day = dayModel;
                dayView.hidden = NO;
            }else{
                dayView.hidden = YES;
            }
        }
        //第一天星期几
        DayModel *day = days[0];
        self.indexNum = day.weekday.intValue;
        
        //计算整体高度
        NSInteger maxRow = (days.count + self.indexNum -2)/7;
        _viewHeight = Ymargin + (maxRow + 1)*(Ymargin + dayHeight);
        
        
        [self setNeedsLayout];
    }else{
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    [self selectViewWithIndex:0];
    
}


- (void)selectViewWithIndex:(NSInteger)index
{
    DayView *dayView = self.daysArr[index];
    [self dayTap:[dayView.gestureRecognizers objectAtIndex:1]];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupDaysInView];
    }
    return self;
}
- (void) setupDaysInView
{
    NSMutableArray *mArr = [NSMutableArray  array];
    for (int i = 0; i < 31; i++) {
        DayView *dayView = [[[NSBundle mainBundle] loadNibNamed:@"DayView" owner:nil options:nil] lastObject];
        dayView.hidden = YES;
        dayView.tag = i;
        [mArr addObject:dayView];
        //添加手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dayLongPressed:)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dayTap:)];
        [dayView addGestureRecognizer:longPress];
        [dayView addGestureRecognizer:tap];
        [self addSubview:dayView];
    }
    self.daysArr = mArr;
//    self.backgroundColor = [UIColor lightGrayColor];

}

- (void)dayTap:(UIGestureRecognizer *)gesture
{
    NSLog(@"%ld",gesture.view.tag);
    DayView *dayView = (DayView *)gesture.view;
    if (self.lastDayView) {
        if (![self.lastDayView isEqual:dayView]) {
            self.lastDayView.showBackgrand = NO;
        }
    }
    dayView.showBackgrand = YES;
    self.lastDayView = dayView;
    [[NSNotificationCenter defaultCenter] postNotificationName:YBDayViewDidTap object:nil userInfo:@{YBDayViewTapDay : dayView,
          YBDayViewTapDayMonth : self.dayViewCalendarMonthModel.month}];
}

- (void)dayLongPressed:(UIGestureRecognizer *)gesture
{
    DayView *dayView = (DayView *)gesture.view;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:YBDayViewDidLongPressed object:nil userInfo:@{YBDayViewLongPressDay : dayView,
          YBDayViewLongPressedDayMonth : self.dayViewCalendarMonthModel.month}];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    NSArray *days = self.dayViewCalendarMonthModel.daysInMonth;
    if (self.indexNum != 0 && days.count != 0) {
        //横向间隔
        CGFloat Xspace = self.bounds.size.width/7;
        for (int i = 0; i < days.count; i++) {
            DayView *dayView = _daysArr[i];
            CGFloat f = self.bounds.size.width/7;
            dayView.frame = CGRectMake(0, 0, self.bounds.size.width/7, dayHeight);
            NSInteger col = (i + self.indexNum - 1)%7;
            NSInteger row = (i + self.indexNum - 1)/7;
            CGFloat dayCenterX = Xspace*0.5 + col*Xspace;
            CGFloat dayCenterY = dayView.bounds.size.height*0.5 + Ymargin + row*(dayView.bounds.size.height + Ymargin);
            dayView.center = CGPointMake(dayCenterX, dayCenterY);
        }
    }

    
}


@end
