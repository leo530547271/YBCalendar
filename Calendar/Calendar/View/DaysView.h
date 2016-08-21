//
//  DaysView.h
//  Calendar
//
//  Created by iLeo-OC on 16/8/18.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalendarMonthModel;
@interface DaysView : UIView


@property (nonatomic, strong) CalendarMonthModel *dayViewCalendarMonthModel;

@property (nonatomic, assign) CGFloat viewHeight;

- (void) selectViewWithIndex:(NSInteger)index;

@end
