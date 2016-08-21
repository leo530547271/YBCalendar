//
//  CalendarView.m
//  Calendar
//
//  Created by iLeo-OC on 16/8/16.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import "CalendarView.h"
#import "DaysView.h"
#import "Masonry.h"
#import "DayView.h"
//横向的的tableView
#import "ZqwPageListView.h"

@interface CalendarView()<UIScrollViewDelegate>
//月日按钮
@property (weak, nonatomic) IBOutlet UILabel *monthDay;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
//几天前
@property (weak, nonatomic) IBOutlet UILabel *selectedDayFromToday;
//年份
@property (weak, nonatomic) IBOutlet UILabel *year;


//横向的tableView
@property (nonatomic, strong) ZqwPageListView *myScrollView;


@property (nonatomic, strong) NSArray *daysArr;

@property (nonatomic, assign) int currentIndex;

@property (weak, nonatomic) IBOutlet UIView *weekDayView;

@end


@implementation CalendarView

- (ZqwPageListView *)myScrollView{
    
    if (nil == _myScrollView) {
        __block CGFloat height;
        __weak typeof(self) weakSelf = self;
        _myScrollView = [ZqwPageListView new];
        
        _myScrollView.clipsToBounds = YES;
//        _myScrollView.backgroundColor = [UIColor greenColor];
        //view个数
        NSInteger numOfDaysView = self.calendarYearModel.calendarMonthArr.count;
        _myScrollView.totalPagesCountBlock = ^NSInteger(void){
            return (numOfDaysView);
        };
        _myScrollView.loadViewAtIndexBlock = ^UIView *(NSInteger pageIndex,UIView *dequeueView){
            DaysView *daysView = nil;
            if (nil == dequeueView) {
                dequeueView = [[UIView alloc] initWithFrame:weakSelf.myScrollView.bounds];
                dequeueView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                //创建一个daysView
                daysView = [[DaysView alloc] init];
                daysView.tag = 1;
//                daysView.backgroundColor = [UIColor redColor];
                [dequeueView addSubview:daysView];
            }
            else{
                daysView = (DaysView *)[dequeueView viewWithTag:1];
                
            }
            if (pageIndex < numOfDaysView) {
                CalendarMonthModel *monthModel = weakSelf.calendarYearModel.calendarMonthArr[pageIndex];
                daysView.dayViewCalendarMonthModel = monthModel;
                daysView.frame = CGRectMake(0, 0, weakSelf.bounds.size.width, daysView.viewHeight);
                height = 35+45+daysView.viewHeight;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    weakSelf.monthDay.text = [NSString stringWithFormat:@"%@月" ,monthModel.month];
                    
                });
            }
            
            return dequeueView;
        };
        self.myHeight = height;
    }
    
    return _myScrollView;
}


- (NSArray *)daysArr
{
    if (_daysArr == nil) {
        _daysArr = [NSArray array];
    }
    return _daysArr;
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(arriveCurrentPage:) name:YBCalendarArriveCurrentPage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayDidClicked:) name:YBDayViewDidTap object:nil];
}

- (void) dayDidClicked:(NSNotification *) myNotification
{
    DayView *dayView = myNotification.userInfo[YBDayViewTapDay];
    DayModel *dayModel = dayView.day;
    self.dayLabel.text = [NSString stringWithFormat:@"%@日" ,dayModel.dayInMonth];
}

- (void) arriveCurrentPage:(NSNotification *) notification
{
    NSNumber *pageIndex = notification.userInfo[YBCalendarCurrentPage];
    if (self.currentIndex != pageIndex.intValue) {
        CalendarMonthModel *monthModel = self.calendarYearModel.calendarMonthArr[pageIndex.intValue];
        self.monthDay.text = [NSString stringWithFormat:@"%@月" ,monthModel.month];
    }
    self.currentIndex = pageIndex.intValue;
    
}

- (void)setCalendarYearModel:(CalendarYearModel *)calendarYearModel
{
    _calendarYearModel = calendarYearModel;
    //显示年份
    self.year.text = calendarYearModel.year;
    //显示平年闰年
    if (calendarYearModel.isLeapYear) {
        _selectedDayFromToday.text = @"闰年";
    }else{
        _selectedDayFromToday.text = @"平年";
    }
    __weak typeof(self) weakSelf = self;
    [self addSubview:self.myScrollView];
    [_myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.weekDayView.mas_bottom);
        make.bottom.right.left.mas_equalTo(weakSelf);
    }];
    
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DaysView * firstDaysView = [[DaysView alloc] init];
        firstDaysView.dayViewCalendarMonthModel = [self.calendarYearModel.calendarMonthArr firstObject];
        CGFloat height = firstDaysView.viewHeight + 35 + 45;
        [[NSNotificationCenter defaultCenter] postNotificationName:YBCalendarShouldChangeHeight object:nil userInfo: @{YBCalendarRealHeight : @(height)}];
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}









@end
