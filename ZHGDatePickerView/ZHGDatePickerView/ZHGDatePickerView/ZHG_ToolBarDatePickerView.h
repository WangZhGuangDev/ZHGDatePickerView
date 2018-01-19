//
//  DD_ToolBarDatePickerView.h
//  DingDing
//
//  Created by DDing_Work on 2017/12/14.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHG_CustomDatePickerView.h"

@interface ZHG_ToolBarDatePickerView : UIView

/** 时间选择器类型 */
@property (nonatomic, assign) ZHG_CustomDatePickerView_Type datePickerType;


/**
 最小日期
 */
@property (nonatomic, strong) NSDate *minDate;

/**
 最大日期
 */
@property (nonatomic, strong) NSDate *maxDate;

/**
 默认日期，即初始化时默认滚动到的日期，若是设置了最小日期，默认日期一定要大于或等于最小日期，不能小于最小日期（小于最小日期无意义）；同理，若是设置了最大日期，默认日期不能大于最大日期
 */
@property (nonatomic, strong) NSDate *defaultDate;
@property (nonatomic, copy) void(^DatePickerSelectedBlock)(NSString *,NSDate *);

/** 是否限制今天为最大日期，默认为NO，若设置为YES，则最大只能选择到今日 */
@property (nonatomic, assign, getter=isLimitMaxDateToday) BOOL limitMaxDateToday;

/** 中间标题 */
@property (nonatomic, strong) NSString *title;
/** 中间标题字体颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 中间标题字体大小 */
@property (nonatomic, assign) CGFloat titleFontSize;

/** 取消按钮标题 */
@property (nonatomic, strong) NSString *cancelTitle;
/** 取消按钮字体颜色 */
@property (nonatomic, strong) UIColor *cancelTitleColor;
/** 取消按钮字体大小 */
@property (nonatomic, assign) CGFloat cancelTitleFontSize;

/** 确定按钮标题 */
@property (nonatomic, strong) NSString *confirmTitle;
/** 确定按钮字体颜色 */
@property (nonatomic, strong) UIColor *confirmTitleColor;
/** 确定按钮字体大小 */
@property (nonatomic, assign) CGFloat confirmTitleFontSize;

/**
 显示时间选择页面
 */
-(void)show;
@end
