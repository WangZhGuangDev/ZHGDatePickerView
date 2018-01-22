//
//  DD_CustomDatePickerView.h
//  DingDing
//
//  Created by DDing_Work on 2017/12/3.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZHG_CustomDatePickerView_Type) {
    ZHG_CustomDatePickerView_Type_YearMonthDay,              //年月日
    ZHG_CustomDatePickerView_Type_YearMonth,                 //年月
    ZHG_CustomDatePickerView_Type_YearMonthDayHourMinute,    //年月日时分
    ZHG_CustomDatePickerView_Type_HourMinute,                //时分
} NS_AVAILABLE_IOS(9_0);

@interface ZHG_CustomDatePickerView : UIView

/**
 最小日期 注：若在 DD_CustomDatePickerView_Type_HourMinute 模式下设置最小日期，必须同时设置最大日期，且必须是同一天，否则无意义，出问题概不负责
 */
@property (nonatomic, strong) NSDate *minDate;

/**
 最大日期 注：若在 DD_CustomDatePickerView_Type_HourMinute 模式下设置最大日期，必须同时设置最小日期，且必须是同一天，否则无意义，出问题概不负责
 */
@property (nonatomic, strong) NSDate *maxDate;

/**
 默认日期，即初始化时默认滚动到的日期，若是设置了最小日期，默认日期一定要大于或等于最小日期，不能小于最小日期（小于最小日期无意义）；同理，若是设置了最大日期，默认日期不能大于最大日期
 */
@property (nonatomic, strong) NSDate *defaultDate;
/**
 时间选择 block ，选择的 NSString 和 NSDate 类型
 */
@property (nonatomic, copy) void(^DatePickerSelectedBlock)(NSString *,NSDate *);

/** 是否限制今天为最大日期，默认为NO，若设置为YES，则最大只能选择到今日，暂时只对DD_CustomDatePickerView_Type_YearMonthDay 做了处理 */
@property (nonatomic, assign, getter=isLimitMaxDateToday) BOOL limitMaxDateToday;

/**
 时间选择器样式，默认为 ZHG_CustomDatePickerView_Type_YearMonthDay
 */
@property (nonatomic, assign) ZHG_CustomDatePickerView_Type datePickerType;

@end
