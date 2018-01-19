//
//  ZHG_CustomPickerView.m
//  ZHG
//
//  Created by 王忠光 on 2017/12/2.
//  Copyright © 2017年 ZHG. All rights reserved.
//

#import "ZHG_CustomPickerView.h"

@interface ZHG_CustomPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    //标记选择的index，一般最多也就5组component，就按1、2、3、4、5来命名好了
    NSInteger selectIndexOne;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *toolBarView;

@property (nonatomic, strong) UILabel *instruLabel;
@property (nonatomic, assign) BOOL isShowTooBarView;

@end

@implementation ZHG_CustomPickerView
-(instancetype)initWithFrame:(CGRect)frame
                        withDataSource:(NSArray *)dataSource
                         isShowToolBar:(BOOL)isShowToolBar {
    self = [super initWithFrame:frame];
    if (self) {
        self.isShowTooBarView = isShowToolBar;
        self.dataSource = dataSource;
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    
    if (self.isShowTooBarView) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.toolBarView];
        [self.backView addSubview:self.pickerView];
    } else {
        [self addSubview:self.pickerView];
    }
    
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource count];
}
#pragma mark - <UIPickerViewDelegate>

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: selectIndexOne = row;   break;
            
        default:
            break;
    }
    NSString *selectTitle = [self selectedTitle];
    if (self.PikcerViewSelectBlock) {
        self.PikcerViewSelectBlock(selectTitle,selectIndexOne);
    }
}

/**
 每一列的宽度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.width;
}

/**
 每一行的高度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

/**
 返回控件，如果和返回标题的方法同时实现，返回控件的优先级高于标题
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    NSString *title = [self.dataSource objectAtIndex:row];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, pickerView.width, 35))];
    label.text = title;
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.font = FontSize17;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
    
}

-(UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:(CGRectMake(0, self.frame.size.height, self.width, 254))];
        _backView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    return _backView;
}

-(UIView *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 45))];
        _toolBarView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
        UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:(UIControlStateNormal)];
        [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        cancelBtn.titleLabel.font = FontSize15;
        [cancelBtn setFrame:(CGRectMake(10, 0, 60, 45))];
        [_toolBarView addSubview:cancelBtn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake((SCREEN_WIDTH - 100)/2, 0, 100, 45))];
        label.text = self.instruTitle;
        label.textColor = [UIColor colorWithHexString:@"#555555"];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FontSize16;
        [_toolBarView addSubview:label];
        self.instruLabel = label;
        
        UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [confirmBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#2DC4B9"] forState:(UIControlStateNormal)];
        [confirmBtn addTarget:self action:@selector(sureAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
        confirmBtn.titleLabel.font = FontSize15;
        [confirmBtn setFrame:(CGRectMake(SCREEN_WIDTH - 70, 0, 60, 45))];
        [_toolBarView addSubview:confirmBtn];
    }
    return _toolBarView;
}

-(UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:(CGRectMake(0, self.isShowTooBarView ? 45.5 : 0, self.width, self.isShowTooBarView ? 206.5 : self.height))];
        _pickerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

#pragma mark - SEL
-(void)cancelAction:(UIButton *)sender {
    [self dismiss];
}

-(void)sureAction:(UIButton *)sender {
    NSString *selectTitle = [self selectedTitle];
    if (self.PikcerViewSelectBlock) {
        self.PikcerViewSelectBlock(selectTitle,selectIndexOne);
    }
    if (self.SureButtonActionBlock) {
        self.SureButtonActionBlock(selectTitle, selectIndexOne);
    }
    [self dismiss];
}

-(NSString *)selectedTitle {
    return [self.dataSource objectAtIndex:selectIndexOne];
}

-(void)dismiss {
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.backView.frame = CGRectMake(0, weakSelf.frame.size.height , weakSelf.frame.size.width, 254);
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

-(void)show {
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.backView.frame = CGRectMake(0, self.frame.size.height  - 254, SCREEN_WIDTH, 254);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

#pragma mark - setter
-(void)setInstruTitle:(NSString *)instruTitle {
    _instruTitle = instruTitle;
    self.instruLabel.text = instruTitle;
}

-(void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    selectIndexOne = selectIndex;
    [self.pickerView selectRow:selectIndexOne inComponent:0 animated:NO];
}

-(void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.pickerView reloadAllComponents];
}
@end
