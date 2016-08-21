//
//  DayView.h
//  Calendar
//
//  Created by iLeo-OC on 16/8/17.
//  Copyright © 2016年 iLeo-OC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayModel.h"
@interface DayView : UIView

@property (nonatomic, strong) DayModel *day;

@property (nonatomic, assign) BOOL showBackgrand;

@end
