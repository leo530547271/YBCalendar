//
//  CalendarView.h
//  Calendar
//
//  Created by iLeo-OC on 16/8/16.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarYearModel.h"
#import "DayView.h"
@class CalendarView;
@protocol CalendarViewDelegate <NSObject>

- (void) calendarView:(CalendarView *)view didLongPressDay:(DayModel *)day;
- (void) calendarViewDidSwipeLeft;
- (void) calendarViewDidSwipeRight;

@optional
- (void) calendarView:(CalendarView *)view didTapDay:(DayModel *)day;


@end

@interface CalendarView : UIView

@property (nonatomic, strong) CalendarYearModel *calendarYearModel;

@property (nonatomic, weak) id<CalendarViewDelegate> delegate;

@property (nonatomic, assign) CGFloat myHeight;

@end
