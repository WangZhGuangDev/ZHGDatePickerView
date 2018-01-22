//
//  DD_ToolBarDatePickerView.m
//  DingDing
//
//  Created by DDing_Work on 2017/12/14.
//  Copyright © 2017年 ChangTian. All rights reserved.
//

#import "ZHG_ToolBarDatePickerView.h"
#import "ZHG_CustomDatePickerView.h"

#define WEAKSELF(weakSelf) __weak typeof(self) (weakSelf) = self;
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ZHG_ToolBarDatePickerView ()

@property (nonatomic, strong) ZHG_CustomDatePickerView *datePickerView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) NSString *selectedDateString;
@property (nonatomic, strong) NSDate *selectedDate;

@end

static CGFloat CONTENTVIEWHEIGHT = 254;

@implementation ZHG_ToolBarDatePickerView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.toolBarView];
    [self.contentView addSubview:self.separatorLine];
    [self.contentView addSubview:self.datePickerView];
}


-(void)show {
    
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.frame.size.height - CONTENTVIEWHEIGHT, SCREEN_WIDTH, CONTENTVIEWHEIGHT);
    }];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

-(void)dismiss {
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.frame.size.height , weakSelf.frame.size.width, CONTENTVIEWHEIGHT);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

-(UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:(CGRectMake(0, self.frame.size.height, SCREEN_WIDTH, CONTENTVIEWHEIGHT))];
        _contentView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    }
    return _contentView;
}

-(UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 45))];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        
        [_toolBarView addSubview:self.cancelBtn];
        [_toolBarView addSubview:self.titleLabel];
        [_toolBarView addSubview:self.confirmBtn];
    }
    return _toolBarView;
}

-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake((SCREEN_WIDTH - 100)/2, 0, 100, 45))];
        label.text = @"选择日期";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.f];
        _titleLabel = label;
    }
    return _titleLabel;
}

-(UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_cancelBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
        [_cancelBtn setFrame:(CGRectMake(10, 0, 60, 45))];
        [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

-(UIButton *)confirmBtn {
    if (_confirmBtn == nil) {
        UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [confirmBtn setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [confirmBtn setFrame:(CGRectMake(SCREEN_WIDTH - 70, 0, 60, 45))];
        [confirmBtn addTarget:self action:@selector(sureAction:) forControlEvents:(UIControlEventTouchUpInside)];
        _confirmBtn = confirmBtn;
    }
    return _confirmBtn;
}

-(UIView *)separatorLine {
    if (_separatorLine == nil) {
        _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBarView.frame), self.frame.size.width, 0.5)];
        _separatorLine.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    }
    return _separatorLine;
}

-(ZHG_CustomDatePickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [[ZHG_CustomDatePickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.separatorLine.frame), self.frame.size.width, self.contentView.frame.size.height - CGRectGetMaxY(self.separatorLine.frame))];
        WEAKSELF(weakSelf);
        
        _datePickerView.DatePickerSelectedBlock = ^(NSString *selectString, NSDate *selectDate) {
            weakSelf.selectedDateString = selectString;
            weakSelf.selectedDate = selectDate;
        };
    }
    return _datePickerView;
}

#pragma mark - SEL Aciton
-(void)cancelAction:(UIButton *)sender {
    [self dismiss];
}

-(void)sureAction:(UIButton *)sender {
    
    if (self.DatePickerSelectedBlock) {
        self.DatePickerSelectedBlock(self.selectedDateString, self.selectedDate);
    }

    [self dismiss];
}


#pragma mark - setter

-(void)setMinDate:(NSDate *)minDate {
    _minDate = minDate;
    self.datePickerView.minDate = minDate;
}

-(void)setMaxDate:(NSDate *)maxDate {
    _maxDate = maxDate;
    self.datePickerView.maxDate = maxDate;
}

-(void)setDefaultDate:(NSDate *)defaultDate {
    _defaultDate = defaultDate;
    self.datePickerView.defaultDate = defaultDate;
}

-(void)setLimitMaxDateToday:(BOOL)limitMaxDateToday {
    _limitMaxDateToday = limitMaxDateToday;
    self.datePickerView.limitMaxDateToday = limitMaxDateToday;
}

-(void)setDatePickerType:(ZHG_CustomDatePickerView_Type)datePickerType {
    _datePickerType = datePickerType;
    self.datePickerView.datePickerType = datePickerType;
}

-(void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

-(void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

-(void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
}

-(void)setCancelTitle:(NSString *)cancelTitle {
    _cancelTitle = cancelTitle;
    [self.cancelBtn setTitle:cancelTitle forState:(UIControlStateNormal)];
}

-(void)setCancelTitleColor:(UIColor *)cancelTitleColor {
    _cancelTitleColor = cancelTitleColor;
    [self.cancelBtn setTitleColor:cancelTitleColor forState:(UIControlStateNormal)];
}

-(void)setCancelTitleFontSize:(CGFloat)cancelTitleFontSize {
    _cancelTitleFontSize = cancelTitleFontSize;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:cancelTitleFontSize];
}

-(void)setConfirmTitle:(NSString *)confirmTitle {
    _confirmTitle = confirmTitle;
    [self.confirmBtn setTitle:confirmTitle forState:(UIControlStateNormal)];
}

-(void)setConfirmTitleColor:(UIColor *)confirmTitleColor {
    _confirmTitleColor = confirmTitleColor;
    [self.confirmBtn setTitleColor:confirmTitleColor forState:(UIControlStateNormal)];
}

-(void)setConfirmTitleFontSize:(CGFloat)confirmTitleFontSize {
    _confirmTitleFontSize = confirmTitleFontSize;
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:confirmTitleFontSize];
}

@end
